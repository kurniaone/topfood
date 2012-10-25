
class PositionsController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @positions = Position.paginate(:page => params[:page])
    respond_with @positions
  end

  def new
    @position = Position.new
    respond_with @position do |format|
      format.js { render layout: false }
    end
  end

  def create
    @position = Position.new(params[:position])
    flash[:notice] = 'Position saved' if @position.save
    respond_with @position, location: positions_path
  end

  def edit
    respond_with @position
  end

  def update
    flash[:notice] = 'Position updated' if @position.update_attributes(params[:position])
    respond_with @position, location: positions_path
  end

  def destroy
    flash[:notice] = @position.destroy ? 'Position removed' : 'Failed remove position'
    respond_with @position
  end

  protected
    def find_object
      @position = Position.find(params[:id])
    end
end
