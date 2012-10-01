
class SessionsController < Devise::SessionsController
  def create
    if params[:with_captcha] == 'true' && !verify_recaptcha
      resource = build_resource
      resource.valid?
      resource.errors.add(:base, "There was an error with the recaptcha code below. Please re-enter the code.")

      clean_up_passwords(resource)
      respond_with(resource, serialize_options(resource))
    else
      flash.delete :recaptcha_error
      super
    end
  end
end
