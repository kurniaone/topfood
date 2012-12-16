class Api::PasswordsController < ApiController
  before_filter :authenticate_user!
  skip_before_filter :require_token
  helper DeviseHelper

  def create
    resource = User.send_reset_password_instructions(params[:user])

    if resource && resource.errors.blank? && !resource.try(:id).blank?
      render json: {
        success: true,
        message: "You will receive an email with instructions about how to reset your password in a few minutes."
      }
    else
      render json: {
        success: false,
        errors: resource.try(:errors).try(:full_messages)
      }
    end
  end

  def update
    resource = User.reset_password_by_token(params[:user])
    if resource.errors.empty?
      sign_in(:user, resource)
      resource.ensure_authentication_token!

      render json: {
        success: true,
        auth_token: resource.authentication_token,
        email: resource.email,
        message: "Your password was changed successfully. You are now signed in."
      }
    else
      render json: {
        success: false,
        errors: resource.try(:errors).try(:full_messages)
      }
    end
  end
end
