class Api::DepartmentsController < ApiController
  before_filter :find_object, :only => [:show, :update, :destroy]

  def index
    @departments = Department.paginate(:page => params[:page])
    respond_with @departments
  end

  def create
    @department = Department.new(params[:department])
    @department.save
    respondjson @department
  end

  def update
    @department.update_attributes(params[:department])
    respondjson @department
  end

  def destroy
    @department.destroy
    respondjson @department
  end

  protected
    def find_object
      @department = Department.find_by_code(params[:id])
    end
end
