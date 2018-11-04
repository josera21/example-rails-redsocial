class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, omniauth_providers: [:facebook]

  has_many :posts
  has_many :friendships

  # Metodos de relacion, para que rails maneje sobre si seguimos a alguien o no, pero en el modelo
  # Friendship lo hemos hecho manualmente, lo decidi asi por que no estaba entendiendo las relaciones 
  # Followers, friends_added, friends_who_added

  # Si no le coloco el foreign key, rails va a tratar de buscar el belongs_to :user en Friendship,
  # Pero lo que queremos que es busque donde yo soy el amigo
  # has_many :followers, class_name: "Friendship", foreign_key: "friend_id"

  # colocamos friend como source para que me duvuelva a los amigos a los que yo he agregado 
  # has_many :friends_added, through: :friendships, source: :friend
  # Los amigos que me agregaron
  # has_many :friends_who_added,through: :friendships, source: :user


  # has_attached_file es un metodo de la gema de paperclip para hacer el manejo de las imagenes.
  # En el hash del styles, pasamos los diferentes tamanos que queramos para la imagen
  # se le puede asignar cualquier nombre a estos tamanos.
  # default_url es utilizado para que cuando el campo avatar por ejm no tenga una imagen asignada.
  has_attached_file :avatar, styles: {thumb: "100x100", medium: "300x300"}, default_url: "/images/:style/missing.png"
  # Aqui validamos para que solo permita guardar imagenes y asi no tener vulnerabilidades
  # por si alguien sube archivos con extension maliciosa
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_attached_file :cover, styles: {thumb: "400x300", medium: "800x600"}, default_url: "/images/:style/missing_cover.jpg"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  validates :username, presence: true, uniqueness: true, length: {in: 3..12}
  # Validaciones personalizadas. solo nombramos validate (sin s) y el nombre del metodo
  validate :validate_username_regex

  def friend_ids
    # Yo soy el user => friend_id
    # SELECT friend_id FROM friendships WHERE user_id = 4;
    Friendship.active.where(user:self).pluck(:friend_id)
  end

  def user_ids
    # Yo soy el friend => user_id
    Friendship.active.where(friend:self).pluck(:user_id)
  end

  def unviewed_notifications_count
    # Reciclo el mismo metodo del model notification para ver cuantas notificaciones no han sido vistas
    Notification.for_user(self.id)
  end

  def self.from_omniauth(auth)
  	where(provider: auth[:provider], uid: auth[:uid]).first_or_create do |user|
  		if auth[:info]
  			user.email = auth[:info][:email]
  			user.name = auth[:info][:name]
  		end
  		user.password = Devise.friendly_token[0,20]
  	end
  end

  def my_friend?(friend)
    # Como la logica de la relacion entre amigos le pertenece a Friendship, es por eso que creamos el 
    # Metodo friends? para realizar el query donde corresponde
    Friendship.friends?(self, friend)
  end

  private
  def validate_username_regex
    # Con =~ verificamos si el usuario que pasamos, cumple con las caracteristicas especificadas
    unless username =~ /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_]*\z/
      errors.add(:username, "El username debe iniciar con letras y no se permite caracteres especiales")
    end
  end
end
