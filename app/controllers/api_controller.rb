class ApiController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  before_filter :require_token
  before_filter :authenticate_user!
  helper_method :current_user

  private
    def require_token
      render(text: 'Require auth-token', status: 401) and return if params[:auth_token].blank?
    end

    def authenticate_user!
      if !params[:auth_token].blank? &&
        !(User.find_for_database_authentication(authentication_token: params[:auth_token]))
        render json: { error: "Authentication failed" }
      end
    end

    def respondjson(obj, template = 'show')
      obj.valid? ? render(template) : respond_with(obj)
    end

    def current_user
      @current_user ||= User.find_for_database_authentication(authentication_token: params[:auth_token])
    end

  rescue_from ActiveRecord::RecordNotFound, ActiveRecord::ActiveRecordError, Exception do |error|
    render json: { error: error.message }, status: :not_found
  end
end
