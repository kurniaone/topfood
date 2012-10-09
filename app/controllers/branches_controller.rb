class BranchesController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy, :sm, :assign_sm]

  def index
    @branches = Branch.paginate(:page => params[:page])
    respond_with @branches
  end

  def new
    @branch = Branch.new
    respond_with @branch do |format|
      format.js { render layout: false }
    end
  end

  def create
    @branch = Branch.new(params[:branch])
    flash[:notice] = 'Branch saved' if @branch.save
    respond_with @branch, location: branches_path
  end

  def show
    respond_with @branch
  end

  def edit
    respond_with @branch
  end

  def update
    flash[:notice] = 'Branch updated' if @branch.update_attributes(params[:branch])
    respond_with @branch, location: branches_path
  end

  def destroy
    flash[:notice] = @branch.destroy ? 'Branch removed' : 'Failed remove branch'
    respond_with @branch
  end

  def sm
  end

  def assign_sm
  end

  protected
    def find_object
      @branch = Branch.find(params[:id])
    end
end
