class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :js, :html, :json

  before_filter :authenticate_user!
  helper_method :superadmin, :master_data_controllers, :department_options, :management_options


  protected

    def superadmin
      current_user && current_user.su
    end

    def department_options
      Department.all.map{|d| [d.name, d.id] }
    end

    def management_options
      Management.all.map{|d| [d.name, d.id] }
    end

    def master_data_controllers
      ['positions', 'departments', 'units', '']
    end

end
