class AddAttachmentCoverAndAvatarToUsers < ActiveRecord::Migration[5.1]
  def change
  	add_attachment :users, :avatar
  	add_attachment :users, :cover
  end
end