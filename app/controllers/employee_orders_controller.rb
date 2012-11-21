class EmployeeOrdersController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]
  before_filter :prepare_data, :only => [:edit, :update]

  def index
    if current_user.role?('sm')
      @orders = EmployeeOrder.by_store_manager(current_user).order('created_at DESC').paginate(:page => params[:page])
    elsif current_user.role?('tl')
      @orders = EmployeeOrder.by_team_leader(current_user).order('created_at DESC').paginate(:page => params[:page])
    else
      @orders = EmployeeOrder.order('created_at DESC').paginate(:page => params[:page])
    end
    respond_with @orders
  end

  def new
    @order = EmployeeOrder.new
    prepare_data
    respond_with @order do |format|
      format.js { render layout: false }
    end
  end

  def create
    @order = EmployeeOrder.new(params[:order])
    if @order.save
      @order.send_email_to_approver(employee_order_url(@order))
      flash[:notice] = 'EmployeeOrder saved'
    else
      prepare_data
    end

    respond_with @order
  end

  def edit
    respond_with @order
  end

  def update
    flash[:notice] = 'EmployeeOrder updated' if @order.update_attributes(params[:order])
    respond_with @order, location: employee_orders_path
  end

  def destroy
    flash[:notice] = @order.destroy ? 'EmployeeOrder removed' : 'Failed remove order'
    respond_with @order
  end

  def approve
    approval = Approval.find_by_id(params[:id])
    @order = approval.order

    approval.update_attributes(approved: approved?)
    @order.send_email_to_approver(purchase_order_url(@order)) if approved?
    flash[:notice] = "Order is #{approved? ? 'Approved' : 'Rejected'}"

    redirect_to @order
  end

  protected
    def find_object
      @order = EmployeeOrder.find(params[:id])
    end

    def prepare_data
      @order.employee_details.build if @order.employee_details.blank?
      @department_options = department_options
      @position_options = position_options
    end
end
