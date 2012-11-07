class Api::PurchaseOrdersController < ApiController
  before_filter :find_object, :only => [:show, :update, :destroy, :approve]

  def index
    @orders = PurchaseOrder.where("branch_id IN (?)", current_user.branch_ids).paginate(:page => params[:page])
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

      order_details_attributes: order_details_attributes
    )
    if @order.save
      # Send email to approver
      respondjson @order
    else
      render json: { error: @order.try(:errors).try(:full_messages) }, status: :not_found
    end
  end

  def update
    if @order.update_attributes(
        order_date: params[:order_date],
        created_by: current_user.try(:id),
        branch_id: current_user.try(:branch).try(:id) || params[:branch_id],

        order_details_attributes: order_details_attributes
      )

      respondjson @order
    else
      render json: { error: @order.try(:errors).try(:full_messages) }, status: :not_found
    end
  end

  def destroy
    @order.destroy
    respondjson @order
  end

  def approve
    approver = current_user

    if @approval = @order.approvals.create(
          role_id: approver.role_id,
          role_name: approver.role_name,
          user_id: approver.id,
          user_name: approver.name,
          approved: params[:approved],
          do_at: Time.now
        )
      # send email to approver
      respond_with @approval
    else
      render json: {errors: @approval.try(:errors).try(:full_messages)}
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
