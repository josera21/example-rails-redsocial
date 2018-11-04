# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# Declaro snack con windows, para poder llamar a esa funciona donde quiera
# snackbar es una funcion de la libreria de material design
window.snack = (options)->
	document.querySelector('#global-snackbar').MaterialSnackbar.showSnackbar(options)
	# el div con el id global-snackbar se encuentra en el layout/application

window.loading = false

# Los eventos page:load y page:fecht deben ir para que funcione bien la pagina
$(document).on "page:load page:fetch ready", ()->
	$('.best_in_place').best_in_place()
	$('.mdl-layout__content').scroll ->
		if !window.loading && $(this).scrollTop() > $(document).height() - 450
			window.loading = true
			url = $('.next_page').attr("href")
			$.getScript url if url