class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :js, :html, :json

  before_filter :authenticate_user!
  helper_method :superadmin, :master_data_controllers


  protected

    def superadmin
      current_user && current_user.su
    end

    def master_data_controllers
      ['master_positions', 'master_departments', 'units', '']
    end
end
