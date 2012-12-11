class Api::EmployeeOrdersController < ApiController
  before_filter :find_object, :only => [:show, :update, :destroy, :approve]

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

  def show
    respond_with @order
  end

  def create
    @order = EmployeeOrder.new(
      order_number: params[:order_number],
      order_date: params[:order_date],
      created_by: current_user.try(:id),
      branch_id: current_user.try(:branch).try(:id) || params[:branch_id],

      employee_details_attributes: employee_details_attributes
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

        employee_details_attributes: employee_details_attributes
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

  protected
    def find_object
      @order = EmployeeOrder.find_by_order_number(params[:id]) || EmployeeOrder.find_by_order_number(params[:order_number])
    end

    def employee_details_attributes
      p = []
      params[:employee_details_attributes].each_with_index do |od, idx|
        od = od[idx] unless od[idx].blank?

        p[idx] = {
          id: od[:id],
          description: od[:description],
          department_id: od[:department_id],
          position_id: od[:position_id],
          quantity: od[:quantity],
          gender: od[:gender],
          used_date: od[:used_date],
          _destroy: od[:_destroy]
        }
        p[idx]
      end

      p
    end
end
