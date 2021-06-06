class ConsultAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :question, class_name: "ConsultQuestion", foreign_key: "consult_question_id"

  has_many :consult_answer_images
  has_many :user_consult_answer_votes

  validates :text, presence: true

  accepts_nested_attributes_for :consult_answer_images

  def liked_by_user(user)
    user_consult_answer_votes.where(user_id: user.id, points: 1).count > 0
  end

  def disliked_by_user(user)
    user_consult_answer_votes.where(user_id: user.id, points: -1).count > 0
  end

  def self.hot
    order(points: :desc)
  end
end
