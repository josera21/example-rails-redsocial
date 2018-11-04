class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.references :item, polymorphic: true, index: true
      t.boolean :viewed, default: false
      # Es buena practica inicializar un booleano con un valor por default
      # Se le coloca index true para que sea mas facil hacer joins y hacer busquedas sobre item
      t.timestamps
    end
  end
end
