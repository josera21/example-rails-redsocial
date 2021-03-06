class UsuariosController < ApplicationController
	before_action :set_user
	before_action :authenticate_user!, only: [:update]
	before_action :authenticate_owner!, only: [:update]

	def show
		# Hay que tratar de simplificar los controladores, es decir que los querys deberian estar
		# en el modelo, es por eso que creamos el metodo my_friend?
		@are_friends = current_user.my_friend?(@user)
	end

	def update
		respond_to do |format|
			if @user.update(user_params)
				format.html { redirect_to @user }
				format.json { render :show }
				format.js
			else
				format.html { redirect_to @user, notice:"Error al actualizar"}
				format.json { render json: @user.errors }
				format.js
			end
		end
	end

	private
		def set_user
			@user = User.find(params[:id])
		end

		def authenticate_owner!
			if current_user != @user
				redirect_to root_path, notice:"No estas autorizado", status: :unauthorized
			end
		end

		def user_params
			params.require(:user).permit(:email, :username, :name, :last_name, :bio, :avatar, :cover)
		end
end