
class SettingsController < ApplicationController
  layout 'top-food'
  before_filter :set_type, :find_setting
  respond_to :html

  def index
    @setting.approval_managements.build if @setting.approval_managements.blank?
  end

  def update
    flash[:notice] = @setting.update_attributes(params[:approval_setting]) ? "Setting saved" :
      "Failed save setting"
    redirect_to settings_path(@p)
  end

  protected

    def set_type
      @p = params[:type] || 'purchase'
      @type = 'PurchaseOrder' if @p == 'purchase'
      @type = 'WorkOrder'     if @p == 'work'
      @type = 'EmployeeOrder' if @p == 'employee'
    end

    def find_setting
      @setting = ApprovalSetting.find_by_order_class(@type)
    end
end
