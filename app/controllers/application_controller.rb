class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :js, :html, :json

  before_filter :authenticate_user!
  helper_method :superadmin, :master_data_controllers,
    :department_options, :role_options, :branch_options, :unit_options,
    :gender_options, :status_options


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

    def position_options
      Position.all.map{|d| [d.name, d.id] }
    end

    def role_options
      Role.all.map{|d| [d.name, d.id] }
    end

    def branch_options(user = nil)
      branches = if !user || user.user_branches.blank?
        Branch.not_center
      else
        current_user.branches
      end

      branches.map{|d| [d.name, d.id] }
    end

    def unit_options
      Unit.all.map{|d| [d.name, d.id] }
    end

    def gender_options(l = 'en')
      l == 'id' ? [["Laki-laki", "M"], ["Perempuan", "F"]] : [["Male", "M"], ["Female", "F"]]
    end

    def status_options
      [['Approved', 'approved'], ['Rejected', 'rejected']]
    end

    def approved?
      params[:approved] == "1" || params[:approved] == 1 || params[:approved] == 'true'
    end
end
