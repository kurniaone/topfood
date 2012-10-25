class WorkOrdersController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]
  before_filter :prepare_data, :only => [:edit, :update]

  def index
    if current_user.role?('sm')
      @orders = WorkOrder.by_store_manager(current_user).order('created_at DESC').paginate(:page => params[:page])
    elsif current_user.role?('tl')
      @orders = WorkOrder.by_team_leader(current_user).order('created_at DESC').paginate(:page => params[:page])
    end
    respond_with @orders
  end

  def new
    @order = WorkOrder.new
    prepare_data
    respond_with @order do |format|
      format.js { render layout: false }
    end
  end

  def create
    @order = WorkOrder.new(params[:order])
    if @order.save
      # @order.send_email_to_approver(work_order_url(@order))
      flash[:notice] = 'WorkOrder saved'
    else
      prepare_data
    end

    respond_with @order, location: work_orders_path
  end

  def edit
    respond_with @order
  end

  def update
    flash[:notice] = 'WorkOrder updated' if @order.update_attributes(params[:order])
    respond_with @order, location: work_orders_path
  end

  def destroy
    flash[:notice] = @order.destroy ? 'WorkOrder removed' : 'Failed remove order'
    respond_with @order
  end

  protected
    def find_object
      @order = WorkOrder.find(params[:id])
    end

    def prepare_data
      @order.order_details.build if @order.order_details.blank?
      @unit_options = unit_options
    end
end
