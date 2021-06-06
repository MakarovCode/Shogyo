class UserContact < ApplicationRecord
  belongs_to :user
  belongs_to :interested, class_name: "User", foreign_key: "interested_id"

  validates :interested_id, :message, presence: true

  def are_open
    where closed: false
  end

  def self.between_users(user_id, other_id)
    where("(interested_id = ? AND user_id = ?) OR (interested_id = ? AND user_id = ?)", other_id, user_id, user_id, other_id)
  end

  def self.by_user(user_id)
    where("interested_id = ? OR user_id = ?", user_id, user_id)
  end
end
