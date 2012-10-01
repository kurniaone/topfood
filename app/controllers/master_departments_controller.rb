class MasterDepartmentsController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]

  def index
    @master_departments = MasterDepartment.paginate(:page => params[:page])
    respond_with @master_departments
  end

  def new
    @master_department = MasterDepartment.new
    respond_with @master_department do |format|
      format.js { render layout: false }
    end
  end

  def create
    @master_department = MasterDepartment.new(params[:master_department])
    flash[:notice] = 'Master Position saved' if @master_department.save
    respond_with @master_department, location: master_departments_path
  end

  def edit
    respond_with @master_department
  end

  def update
    flash[:notice] = 'Master Position updated' if @master_department.update_attributes(params[:master_department])
    respond_with @master_department, location: master_departments_path
  end

  def destroy
    flash[:notice] = @master_department.destroy ? 'Master Position removed' : 'Failed remove master position'
    respond_with @master_department
  end

  protected
    def find_object
      @master_department = MasterDepartment.find(params[:id])
    end
end
