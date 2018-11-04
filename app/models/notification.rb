class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :item, polymorphic: true
  after_create { NotificationBroadcastJob.perform_later(self) }
  scope :unviewed, -> { where(viewed: false) }

  def self.for_user(user_id)
  	Notification.where(user_id: user_id).unviewed.count
  end
end
