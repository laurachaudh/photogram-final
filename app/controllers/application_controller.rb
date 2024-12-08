class ApplicationController < ActionController::Base
  skip_forgery_protection

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit additional fields for sign-up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :private])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :private])
  end

  def after_sign_out_path_for(resource_or_scope)
    reset_session
    root_path
  end
end
