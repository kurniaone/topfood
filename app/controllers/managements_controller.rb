
class ManagementsController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]

  def index
    @managements = Management.paginate(:page => params[:page])
    respond_with @managements
  end

  def new
    @management = Management.new
    respond_with @management do |format|
      format.js { render layout: false }
    end
  end

  def create
    @management = Management.new(params[:management])
    flash[:notice] = 'Position saved' if @management.save
    respond_with @management, location: managements_path
  end

  def edit
    respond_with @management
  end

  def update
    flash[:notice] = 'Position updated' if @management.update_attributes(params[:management])
    respond_with @management, location: managements_path
  end

  def destroy
    flash[:notice] = @management.destroy ? 'Position removed' : 'Failed remove position'
    respond_with @management
  end

  protected
    def find_object
      @management = Management.find(params[:id])
    end
end
