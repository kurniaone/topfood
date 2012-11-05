class Api::UsersController < ApiController
  before_filter :find_object, :only => [:show, :update, :destroy]

  def index
    @users = User.not_admin.paginate(:page => params[:page])
    respond_with @users
  end

  # def create
  #   @user = User.new(params[:user])
  #   @user.save
  #   respondjson @user
  # end

  # def update
  #   email_changed = @user.email != params[:user][:email]
  #   password_changed = !params[:user][:password].empty?
  #   if email_changed || password_changed
  #     @user.update_attributes(params[:user])
  #   else
  #     @user.update_without_password(params[:user])
  #   end

  #   respondjson @user
  # end

  # def destroy
  #   @user.destroy
  #   respondjson @user
  # end

  protected
    def find_object
      @user = User.find(params[:id])
    end
end
