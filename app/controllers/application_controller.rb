class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  def unauthenticate_user
    unless request.headers['Authorization'].present?

      render json: {
              messagge: "Unauthorized Users! You need to sign in or sign up before actions."
            }, status: :unprocessable_entity

    end
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])

    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end
end
