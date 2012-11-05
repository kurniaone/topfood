class Api::RolesController < ApiController
  before_filter :find_object, :only => [:show, :update, :destroy]

  def index
    @roles = Role.paginate(:page => params[:page])
    respond_with @roles
  end

  def create
    @role = Role.new(params[:role])
    @role.save
    respondjson @role
  end

  def update
    @role.update_attributes(params[:role])
    respondjson @role
  end

  def destroy
    @role.destroy
    respondjson @role
  end

  protected
    def find_object
      @role = Role.find_by_code(params[:id])
    end
end
