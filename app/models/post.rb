class Post < ApplicationRecord
  include Notificable
  belongs_to :user
  # Si el query ocupa una sola linea, lo mejor es utilizar scope
  scope :nuevos, ->{ order("created_at desc") }
  after_create :send_to_action_cable

  def user_ids
    # Metodo necesario para enviar las notificaiones
    self.user.friend_ids + self.user.user_ids
  end

  def self.all_for_user(user)
  	Post.where(user_id: user.id).or(Post.where(user_id: user.friend_ids))
  		.or(Post.where(user_id: user.user_ids))
  end

  private
  	def send_to_action_cable
  		# Este es el mensaje que le voy a enviar a todas las web sockets
  		data = {message: to_html, action:"new_post"}

  		self.user.friend_ids.each do |friend_id|
  			# Llamo al metodo demo que esta en post_channel
  			ActionCable.server.broadcast "posts_#{friend_id}", data
  		end

  		self.user.user_ids.each do |friend_id|
  			ActionCable.server.broadcast "posts_#{friend_id}", data
  		end
  	end

  	def to_html
  		# Desde Rails 5 se puede hacer render desde cualquier parte de la aplicacion
  		# lo que va en locas es la variable que esta en el partial.
  		PostsController.renderer.render(partial: "posts/post",locals:{post: self})
  	end
end
