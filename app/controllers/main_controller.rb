class MainController < ApplicationController
  def home
    # Para que al hacer render del form post en el home, no de error de @post nil or vacio
    @post = Post.new 
    @posts = Post.all_for_user(current_user).nuevos.paginate(page:params[:page], per_page:8)

    respond_to do |format|
      format.html {}
      format.js {}
    end

  end

  def unregistered
  end

  protected
  def set_layout
  	# Hago overriew del metodo de ApplicationController para cambiar de layout.
  	return 'landing' if action_name == 'unregistered'
  	super
  end
end
