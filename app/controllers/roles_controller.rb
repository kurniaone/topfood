class RolesController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]

  def index
    @roles = Role.paginate(:page => params[:page])
    respond_with @roles
  end

  def new
    @role = Role.new
    respond_with @role do |format|
      format.js { render layout: false }
    end
  end

  def create
    @role = Role.new(params[:role])
    flash[:notice] = 'Role saved' if @role.save
    respond_with @role, location: roles_path
  end

  def edit
    respond_with @role
  end

  def update
    flash[:notice] = 'Role updated' if @role.update_attributes(params[:role])
    respond_with @role, location: roles_path
  end

  def destroy
    flash[:notice] = @role.destroy ? 'Role removed' : 'Failed remove role'
    respond_with @role
  end

  protected
    def find_object
      @role = Role.find(params[:id])
    end
end
