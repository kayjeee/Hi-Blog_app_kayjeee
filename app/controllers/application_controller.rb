# Define a class called ApplicationController that inherits from ActionController::Base
class ApplicationController < ActionController::Base
  # Enable protection from Cross-Site Request Forgery (CSRF) attacks
  protect_from_forgery with: :exception

  # Execute the following method before any controller action is performed
  before_action :authenticate_user!

  # Execute the configure_permitted_parameters method only if the controller is a Devise controller
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Define a method to configure permitted parameters for Devise
  def configure_permitted_parameters
    # Allow the 'name' parameter to be passed during user sign-up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
