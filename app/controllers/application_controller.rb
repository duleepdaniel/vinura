class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[username email password password_confirmation remember_me])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login username email password remember_me])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[username email password password_confirmation current_password])
  end

  def current_user?(user)
    current_user.id == user.id
  end

  helper_method :current_user?
end
