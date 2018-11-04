class OmniauthCallbacksController < ApplicationController
	def facebook
		@user = User.from_omniauth(auth_hash)

		if @user.persisted?
			@user.remember_me = true # Para que se mantenga la sesion a pesar de cerrar el navegador
			sign_in_and_redirect @user, event: :authentication
			return
		end

		session["devise.auth"] = auth_hash

		render :edit
	end

	def custom_sign_up
		@user = User.from_omniauth(session["devise.auth"])
		if @user.update(user_params)
			sign_in_and_redirect @user, event: :authentication
		else
			render :edit
		end
	end

	def failure
		redirect_to new_user_session_path, notice: "No pudimos loguearte. #{params[:error_description]}"
	end

	protected
	def auth_hash
		request.env["omniauth.auth"]
	end

	private
	def user_params
		params.require(:user).permit(:name, :username, :email)
	end
end
