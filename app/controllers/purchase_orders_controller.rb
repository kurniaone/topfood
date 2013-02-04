class PurchaseOrdersController < ApplicationController
  authorize_resource
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy, :received, :done]
  before_filter :prepare_data, :only => [:edit, :update]

  def index
    @orders = current_user.all_orders(PurchaseOrder, params[:search]).order('created_at DESC').paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.xls
    end
  end

  def new
    @order = PurchaseOrder.new
    prepare_data
    respond_with @order do |format|
      format.js { render layout: false }
    end
  end

  def create
    @order = PurchaseOrder.new(params[:order].merge!(updated_by: 'server'))
    if @order.save
      @order.send_email_to_approver(purchase_order_url(@order))
      flash[:notice] = 'PurchaseOrder saved'
    else
      prepare_data
    end

    respond_with @order
  end

  def edit
    respond_with @order
  end

  def update
    flash[:notice] = 'PurchaseOrder updated' if @order.update_attributes(params[:order].merge!(updated_by: 'server'))
    respond_with @order, location: purchase_order_path(@order)
  end

  def destroy
    flash[:notice] = @order.destroy && @order.update_attributes(updated_by: 'server') ? 'PurchaseOrder removed' : 'Failed remove order'
    respond_with @order, location: purchase_orders_path
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
      @order = PurchaseOrder.find(params[:id])
    end

    def prepare_data
      @order.order_details.build if @order.order_details.blank?
      @unit_options = unit_options
    end

end
