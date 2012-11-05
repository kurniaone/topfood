class Api::UnitsController < ApiController
  before_filter :find_object, :only => [:show, :update, :destroy]

  def index
    @units = Unit.paginate(:page => params[:page])
    respond_with @units
  end

  def create
    @unit = Unit.new(params[:unit])
    @unit.save
    respondjson @unit
  end

  def update
    @unit.update_attributes(params[:unit])
    respondjson @unit
  end

  def destroy
    @unit.destroy
    respondjson @unit
  end

  protected
    def find_object
      @unit = Unit.find_by_code(params[:id])
    end
end
