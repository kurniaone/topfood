class MasterPositionsController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @master_positions = MasterPosition.paginate(:page => params[:page])
    respond_with @master_positions
  end

  def new
    @master_position = MasterPosition.new
    respond_with @master_position do |format|
      format.js { render layout: false }
    end
  end

  def create
    @master_position = MasterPosition.new(params[:master_position])
    flash[:notice] = 'Master Position saved' if @master_position.save
    respond_with @master_position, location: master_positions_path
  end

  def edit
    respond_with @master_position
  end

  def update
    flash[:notice] = 'Master Position updated' if @master_position.update_attributes(params[:master_position])
    respond_with @master_position, location: master_positions_path
  end

  def destroy
    flash[:notice] = @master_position.destroy ? 'Master Position removed' : 'Failed remove master position'
    respond_with @master_position
  end

  protected
    def find_object
      @master_position = MasterPosition.find(params[:id])
    end
end
