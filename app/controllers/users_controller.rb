
class UsersController < ApplicationController
  layout 'top-food'
  before_filter :find_object, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.not_admin.paginate(:page => params[:page])
    respond_with @users
  end

  def new
    @user = User.new
    @user.user_branches.build
    respond_with @user do |format|
      format.js { render layout: false }
    end
  end

  def create
    @user = User.new(params[:user])
    flash[:notice] = 'User saved' if @user.save
    respond_with @user
  end

  def edit
    @user.user_branches.build if @user.user_branches.blank?
    respond_with @user
  end

  def update
    email_changed = @user.email != params[:user][:email]
    password_changed = !params[:user][:password].empty?
    if email_changed || password_changed
      @user.update_attributes(params[:user])
    else
      @user.update_without_password(params[:user])
    end

    flash[:notice] = 'User updated' if @user.valid?
    respond_with @user
  end

  def destroy
    flash[:notice] = @user.destroy ? 'User removed' : 'Failed remove user'
    respond_with @user
  end

  protected
    def find_object
      @user = User.find(params[:id])
    end
end
