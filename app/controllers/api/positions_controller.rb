class Api::PositionsController < ApiController
  before_filter :find_object, :only => [:show, :update, :destroy]

  def index
    @positions = Position.paginate(:page => params[:page])
    respond_with @positions
  end

  def create
    @position = Position.new(params[:position])
    @position.save
    respondjson @position
  end

  def update
    @position.update_attributes(params[:position])
    respondjson @position
  end

  def destroy
    @position.destroy
    respondjson @position
  end

  protected
    def find_object
      @position = Position.find_by_code(params[:id])
    end
end
