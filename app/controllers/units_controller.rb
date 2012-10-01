class UnitsController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]

  def index
    @units = Unit.paginate(:page => params[:page])
    respond_with @units
  end

  def new
    @unit = Unit.new
    respond_with @unit do |format|
      format.js { render layout: false }
    end
  end

  def create
    @unit = Unit.new(params[:unit])
    flash[:notice] = 'Unit saved' if @unit.save
    respond_with @unit, location: units_path
  end

  def edit
    respond_with @unit
  end

  def update
    flash[:notice] = 'Unit updated' if @unit.update_attributes(params[:unit])
    respond_with @unit, location: units_path
  end

  def destroy
    flash[:notice] = @unit.destroy ? 'Unit removed' : 'Failed remove master position'
    respond_with @unit
  end

  protected
    def find_object
      @unit = Unit.find(params[:id])
    end
end
