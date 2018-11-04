class FriendshipsController < ApplicationController
	before_action :find_friend, except: [:index, :update]
	before_action :find_friendship, only: [:update]

	def index
		# Decorate para que los obj que vienen de la BD sean una instancia de FriendshipDecorator
		@pending_friendships = Friendship.pending_for_user(current_user).decorate
		@accepted_friendships = Friendship.accepted_for_user(current_user).decorate
		@pending_requests = Friendship.send_for_user(current_user).decorate
	end

	def create
		friendship = Friendship.new(user: current_user, friend: @friend)
		# en la migration de friendship, se coloco foreign key como false, debido a que intentaba
		# buscar una tabla llamada friends, a pesar de espeficar el class_name en el modelo
		respond_to do |format|
			if friendship.save
				format.html { redirect_to @friend }
				format.js { render :create}
			else
				format.html { redirect_to @friend, notice: "Error con la solicitud de amistad" }
				format.js {}
			end
		end
	end

	def update
		# Con el ! al final, le indicamos que ademas de cambiar el recurso, que lo guarde en la BD
		if params[:status] == "yes"
			@friendship.accepted!
		elsif params[:status] == "no"
			@friendship.rejected!				
		end

		respond_to do |format|
			format.html{ redirect_to friendships_path }
		end
	end

	private
		def find_friend
			@friend = User.find(params[:friend_id])
		end

		def find_friendship
			@friendship = Friendship.find(params[:id])
		end
end