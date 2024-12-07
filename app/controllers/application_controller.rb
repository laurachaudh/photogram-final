class ApplicationController < ActionController::Base
  skip_forgery_protection

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit additional fields for sign-up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :private])
  end
end

