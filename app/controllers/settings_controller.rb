
class SettingsController < ApplicationController
  layout 'top-food'
  before_filter :set_type, :find_setting
  respond_to :html

  def index
    @centersetting.approval_roles.build if @centersetting.approval_roles.blank?
    @branchsetting.approval_roles.build if @branchsetting.approval_roles.blank?
  end

  def update
    valid = (params[:center] && @centersetting.update_attributes(params[:center])) ||
      (params[:branch] && @branchsetting.update_attributes(params[:branch]))
    flash[:notice] = valid ? "Setting saved" : "Failed save setting"
    if valid
      redirect_to settings_path(@p)
    else
      render :index
    end


  end

  protected

    def set_type
      @p = params[:type] || 'purchase'
      @type = 'PurchaseOrder' if @p == 'purchase'
      @type = 'WorkOrder'     if @p == 'work'
      @type = 'EmployeeOrder' if @p == 'employee'
    end

    def find_setting
      @centersetting = ApprovalSetting.find_by_order_class_and_center(@type, true)
      @branchsetting = ApprovalSetting.find_by_order_class_and_center(@type, false)
    end
end
