class Friendship < ApplicationRecord
  include Notificable
  include AASM

  belongs_to :user
  # Como la tabla Friends no existe (ya que es el mismo user) debemos indicarle a Rails como mapear.
  belongs_to :friend,class_name: 'User'

  # Validamos que sea unico la relacion de seguir a un amigo, es decir que puede haber el mismo user_id 
  # en el registro pero no puede ser el mismo friend_id en dos registros.
  # Friendship.create(user_id:2, friend_id:3) y Friendship.create(user_id:2, friend_id:3)
  validates :user_id,uniqueness:{ scope: :friend_id,message: "amistad duplicada" }

  def user_ids
    
  end

  def self.friends?(user,friend)
    # De no ser por el metodo OR el query solo funcionaria en una sola direccion, y la logica es:
    # Si yo soy amigo de Ruby, entonces Ruby es amiga mia.
    # dejar el where solo es lo mismo que poner Friendship.where
    return true if user == friend
    Friendship.where(user: user, friend: friend).or(Friendship.where(user: friend, friend: user)).any?
  end

  def self.pending_for_user(user)
    # Pending nos filtra todas las solicitudes pendientes, ese metodo lo crea el aasm
    Friendship.pending.where(friend: user)
  end

  def self.accepted_for_user(user)
    Friendship.active.where(friend: user)
  end

  def self.send_for_user(user)
    Friendship.pending.where(user: user)
  end

  aasm column: "status" do
  	# Aqui definimo los estados para las solicitudes de seguimiento o amistad
  	state :pending, initial: true
  	state :active
  	state :denied

  	# Definimos dos eventos para indicar si fue aceptada o rechazada la solicitud
  	event :accepted do
  		transitions from: [:pending], to: [:active]
  	end

  	event :rejected do 
  		transitions from: [:pending,:active], to: [:denied]
  	end
  end
end
