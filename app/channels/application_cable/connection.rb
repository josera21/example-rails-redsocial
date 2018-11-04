module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	# Se le puede colocar cualquier nombre, le coloque current_user por convencion, debido a que 
  	# Asi hemos identificado al usuario en los demas modulos
  	identified_by :current_user

  	def connect
  		# Este metodo se ejecuta cuando se conectan a la web sockect
  		self.current_user = find_user
  	end

  	def find_user
  		# El funcionamiento de las cookies se explican en el video 75 del curso de rails 5
  		# Las cookies las traemos desde el inicilizador warden_hooks
  		user_id = cookies.signed["user.id"]
  		current_user = User.find_by(id:user_id)

  		if current_user
  			current_user
  		else
  			reject_unauthorized_connection
  		end
  	end
  end
end
