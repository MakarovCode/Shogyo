class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :publication

  validates :subject, :details, presence: true

  def get_status
    if status == 0 || status.nil?
      "Pendiente"
    else
      "Resuelta"
    end
  end
end
