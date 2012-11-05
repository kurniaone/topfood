class Api::BranchesController < ApiController
  before_filter :find_object, :only => [:show, :update, :destroy]

  def index
    @branches = Branch.paginate(:page => params[:page])
    respond_with @branches
  end

  def show
    respond_with @branch
  end

  def create
    @branch = Branch.new(params[:branch])
    @branch.save
    respondjson @branch
  end

  def update
    @branch.update_attributes(params[:branch])
    respondjson @branch
  end

  def destroy
    @branch.destroy
    respondjson @branch
  end

  protected
    def find_object
      @branch = Branch.find(params[:id])
    end
end
