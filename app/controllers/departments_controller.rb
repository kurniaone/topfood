
class DepartmentsController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]

  def index
    @departments = Department.paginate(:page => params[:page])
    respond_with @departments
  end

  def new
    @department = Department.new
    respond_with @department do |format|
      format.js { render layout: false }
    end
  end

  def create
    @department = Department.new(params[:department])
    flash[:notice] = 'Department saved' if @department.save
    respond_with @department, location: departments_path
  end

  def edit
    respond_with @department
  end

  def update
    flash[:notice] = 'Department updated' if @department.update_attributes(params[:department])
    respond_with @department, location: departments_path
  end

  def destroy
    flash[:notice] = @department.destroy ? 'Department removed' : 'Failed remove department'
    respond_with @department
  end

  protected
    def find_object
      @department = Department.find(params[:id])
    end
end
