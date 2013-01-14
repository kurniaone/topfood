class Api::PurchaseOrdersController < ApiController
  before_filter :require_app_id
  before_filter :find_object, :only => [:show, :update, :destroy, :approve]

  def index
    @orders = current_user.all_orders(PurchaseOrder, params).with_deleted.order('created_at DESC').paginate(:page => params[:page])
    AppsOrder.update_app_timestamp(app_id, @orders)

    respond_with @orders
  end

  def show
    respond_with @order
  end

  def create
    @order = PurchaseOrder.new(
      order_number: params[:order_number],
      order_date: params[:order_date],
      created_by: current_user.try(:id),
      branch_id: current_user.try(:branch).try(:id) || params[:branch_id],
      updated_by: param[:app_id],

      order_details_attributes: order_details_attributes
    )

    if @order.save
      respondjson @order
    else
      responderror(@order)
    end
  end

  def update
    if @order.update_attributes(
        order_date: params[:order_date],
        created_by: current_user.try(:id),
        branch_id: current_user.try(:branch).try(:id) || params[:branch_id],
        updated_by: param[:app_id],

        order_details_attributes: order_details_attributes
      )

      respondjson @order
    else
      responderror(@order)
    end
  end

  def destroy
    @order.destroy
    respondjson @order
  end

  def approve
    errors = []
    errors << "Next approver is #{@order.next_approver.role_name}" unless @order.next_approver == current_user

    @approval = @order.next_approval
    if errors.blank? && @approval && @approval.update_attributes(approved: approved?)
      @order.send_email_to_approver(purchase_order_url(@order)) if approved?
      # send email to approver
      respond_with @approval
    else
      errors += @approval.try(:errors).try(:full_messages)
      render json: {errors: errors}
    end
  end

  def sync
    results = Order.sync(PurchaseOrder, params[:orders], current_user, app_id)
    render json: results
  end

  def to_sync
    @orders = PurchaseOrder.to_sync(app_id)

    unless @orders.blank?
      AppsOrder.update_app_timestamp(app_id, @orders)

      respond_with @orders
    else
      render json: { message: "Already up to date." }
    end
  end

  protected
    def find_object
      @order = PurchaseOrder.find_by_order_number(params[:id]) || PurchaseOrder.find_by_order_number(params[:order_number])
    end

    def order_details_attributes
      p = []
      params[:order_details_attributes].each_with_index do |od, idx|
        od = od[idx] unless od[idx].blank?
        unit = Unit.find_by_code(od[:unit_code])

        p[idx] = {
          id: od[:id],
          description: od[:description],
          quantity: od[:quantity],
          unit_id: unit.try(:id),
          used_date: od[:used_date],
          _destroy: od[:_destroy]
        }
        p[idx]
      end

      p
    end
end
