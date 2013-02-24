class WorkOrdersController < OrdersController
  layout 'top-food'
  before_filter :find_object, only: [:show, :edit, :update, :destroy, :received, :done]
  before_filter :prepare_data, only: [:edit, :update]
  authorize_resource

  def index
    @orders = current_user.all_orders(WorkOrder, params[:search])
                          .order('created_at DESC')
                          .paginate(page: params[:page])

    respond_to do |format|
      format.html
      format.xls
    end
  end

  def new
    @order = WorkOrder.new
    prepare_data
    respond_with @order do |format|
      format.js { render layout: false }
    end
  end

  def create
    @order = WorkOrder.new(params[:order].merge!(updated_by: 'server'))
    if @order.save
      @order.send_email_to_approver(work_order_url(@order))
      flash[:notice] = 'WorkOrder saved'
    else
      prepare_data
    end

    respond_with @order
  end

  def edit
    respond_with @order
  end

  def update
    flash[:notice] = 'WorkOrder updated' if @order.update_attributes(params[:order].merge!(updated_by: 'server'))
    respond_with @order, location: work_order_path(@order)
  end

  def destroy
    flash[:notice] = @order.destroy && @order.update_attributes(updated_by: 'server') ? 'WorkOrder removed' : 'Failed remove order'
    respond_with @order, location: work_orders_path
  end

  def approve
    approval = Approval.find_by_id(params[:id])
    @order = approval.order

    if approval.update_attributes(approved: approved?, reason: params[:reason]) && @order.update_attributes(updated_by: 'server')
      @order.send_email_to_approver(purchase_order_url(@order)) if approved?
      flash[:notice] = "Order is #{approved? ? 'Approved' : 'Rejected'}"
    else
      flash[:alert] = approval.errors.try(:full_messages).try(:join, ', ')
    end

    redirect_to @order
  end

  def received
    authorize! :received, @order
    if @order.update_attributes(implement_status: 'received')
      flash[:notice] = "Order is already marked as received"
    else
      flash[:notice] = @order.errors.try(:full_messages).try(:join, ', ')
    end

    redirect_to @order
  end

  def done
    authorize! :done, @order
    if @order.update_attributes(implement_status: 'done')
      flash[:notice] = "Order is already marked as done"
    else
      flash[:notice] = @order.errors.try(:full_messages).try(:join, ', ')
    end

    redirect_to @order
  end

  protected
    def find_object
      @work_order = @order = WorkOrder.find(params[:id])
    end

    def prepare_data
      @order.order_details.build if @order.order_details.blank?
      @unit_options = unit_options
    end
end
