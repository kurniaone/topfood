class Api::SessionsController < ApiController
  before_filter :authenticate_user!, except: [:create]
  before_filter :require_token, except: [:create]
  before_filter :ensure_params_exist, only: [:create]

  def create
    resource = User.find_for_database_authentication(:email => params[:user][:email])
    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      sign_in(:user, resource)
      resource.ensure_authentication_token!

      render json: {
        success: true,
        auth_token: resource.authentication_token,
        email: resource.email
      }
      return
    end

    invalid_login_attempt
  end

  def destroy
    resource = User.find_for_database_authentication(:authentication_token => params[:auth_token])
    if resource
      sign_out(:user)
      resource.authentication_token = nil
      render json: { success: resource.save }
    else
      render json: { success: false }
    end
  end

protected

  def ensure_params_exist
    return unless params[:user].blank?
    render json: {
      success: false,
      message: "missing user parameter"
    }, status: 422
  end

  def invalid_login_attempt
    warden.custom_failure!
    render json: {
      success: false,
      message: "Error with your login or password"
    }, status: 401
  end
end
