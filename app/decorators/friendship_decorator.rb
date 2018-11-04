class FriendshipDecorator < Draper::Decorator
  delegate_all

  def user_view
  	# si el objeto es el mismo usuario que visita "Mis amigos" devuelo al objeto amigo
  	# debido a que en la vista solo mostraba al objeto user, lo cual generaba un bug
  	if object.user == h.current_user
  		return object.friend
  	end
  	return object.user
  end

  def status_or_buttons
  	return status if object.user == h.current_user 
  	return buttons if object.pending?
  end

  # no me parece que sepamos quien nos rechazo, ademas que era redundante
  # decir aceptado, por que ya lo mostrabamos en la seccion de Amistades
  def status
  	return "Esperando respuesta" if object.pending?
  	# return "Aceptada" if object.active?
  	# return "Rechazada" if object.denied?
  end

  def buttons
  	# Si no le colocamos html_safe, va a mostrar las etiquetas como texto plano
  	(confirm_button + denegate_button).html_safe
  end

  def confirm_button
  	h.link_to "Aceptar", h.friendship_path(object, status: "yes"),method: :patch, class:"mdl-button mdl-js-button mdl-button--primary"
  end

  def denegate_button
  	h.link_to "Rechazar", h.friendship_path(object, status: "no"),method: :patch, class:"mdl-button mdl-js-button mdl-button--accent"
  end

  # Cuando hago referencia a Object, se trata de friendship

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
