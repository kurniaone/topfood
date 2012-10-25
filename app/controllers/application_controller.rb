class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :js, :html, :json

  before_filter :authenticate_user!
  helper_method :superadmin, :master_data_controllers,
    :department_options, :role_options, :branch_options, :unit_options


  protected

    def superadmin
      current_user && current_user.su
    end

    def master_data_controllers
      ['positions', 'departments', 'units', '']
    end

    def department_options
      Department.all.map{|d| [d.name, d.id] }
    end

    def role_options
      Role.all.map{|d| [d.name, d.id] }
    end

    def branch_options
      Branch.not_center.map{|d| [d.name, d.id] }
    end

    def unit_options
      Unit.all.map{|d| [d.name, d.id] }
    end

end
