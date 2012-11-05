class ApiController < ApplicationController
  respond_to :js
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!

  before_filter :require_key

  private
    def require_key
      render(text: 'Invalid key', status: 401) and return if params[:key].blank?
    end

    def respondjson(obj, template = 'show')
      obj.valid? ? render(template) : respond_with(obj)
    end


  rescue_from ActiveRecord::RecordNotFound, ActiveRecord::ActiveRecordError, Exception do |error|
    render :json => {:error => error.message}, :status => :not_found
  end
end
