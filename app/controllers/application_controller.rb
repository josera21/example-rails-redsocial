class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :set_layout
  # Configuramos los strong params para que devise permita pasar el username al registrar un user
  before_action :configurar_strong_params, if: :devise_controller?

  protected
  def set_layout
  	"application"
  end
  
  def configurar_strong_params
  	# Le estamos diciendo a devise, que en la accion sign_up permita el username
  	devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
