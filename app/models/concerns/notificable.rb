module Notificable
	extend ActiveSupport::Concern
	included do
		# Decimos que las busque en item que es polimorfico, entonces ahi va
		# a buscar item_id e item_type 
		has_many :notifications, as: :item
		after_commit :send_notification_to_users
	end

	def send_notification_to_users
		# Con este metodo validamos que el item tiene el metodo user_ids
		if self.respond_to? :user_ids
			#JOB => mandar las notificaciones async
			NotificationSenderJob.perform_later(self)
		end
	end
end

=begin
 Ejemplo de como funciona item de manera polimorfica
 Se crea un post: Post{id:1}
 Se crea la notificacion: Notification{user_id:1,item_id:1(el id del post),item_type:"Post"}

 nota:
  Para ver un poco mas de informacion sobre los Jobs, ver video 79 del curso Rails 5
=end