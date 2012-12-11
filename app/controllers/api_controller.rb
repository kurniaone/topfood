class ApiController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  before_filter :require_token
  before_filter :authenticate_user!

  # helper_method :current_user

  private
    def require_token
      render(text: 'Require auth-token', status: 401) and return if params[:auth_token].blank?
    end

    def respondjson(obj, template = 'show')
      obj.valid? ? render(template) : respond_with(obj)
    end

    def get_user
      render json: { error: "Require params[:as]" } if params[:as].blank?
    end

    # def current_user
    #   @current_user = User.find_by_email(params[:as] || params[:current_user])
    # end

  rescue_from ActiveRecord::RecordNotFound, ActiveRecord::ActiveRecordError, Exception do |error|
    render json: { error: error.message }, status: :not_found
  end
end
