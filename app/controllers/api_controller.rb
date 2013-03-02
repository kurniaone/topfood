class ApiController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  before_filter :require_token
  before_filter :authenticate_user!

  helper_method :current_user

  private
    def require_token
      render(text: 'Require auth_token', status: 401) and return if params[:auth_token].blank?
    end

    def require_app_id
      render(text: 'Require app_id', status: 401) and return if params[:app_id].blank?
    end

    def authenticate_user!
      if params[:auth_token].blank?
        render json: { error: "Authentication failed" }
      else
        @current_user = User.find_for_database_authentication(authentication_token: params[:auth_token])
      end

      if @current_user && @current_user.token_expired < Time.now
        @current_user.reset_authentication_token!
        render json: { error: "Token is expired after 24 hours" }
      end
    end

    def respondjson(obj, template = 'show')
      obj.valid? ? render(template) : respond_with(obj)
    end

    def responderror(obj)
      render json: { error: obj.try(:errors).try(:full_messages) }, status: :not_found
    end

    def current_user
      @current_user ||= User.find_for_database_authentication(authentication_token: params[:auth_token])
    end

    def app_id
      @app_id ||= params[:app_id]
    end

    def user_branch_id branch_id
      current_user.branches.map(&:id).include?(branch_id) ? branch_id : current_user.try(:branch).try(:id)
    end

  # rescue_from ActiveRecord::RecordNotFound, ActiveRecord::ActiveRecordError, Exception do |error|
  #   render json: { error: error.message }, status: :not_found
  # end
end
