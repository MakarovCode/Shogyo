class PublicationQuestion < ApplicationRecord
  belongs_to :publication
  belongs_to :user

  validates :question, presence: true

  def self.pending(user)
    includes(:publication).where({publications: {user_id: user.id}, answer: [nil, ""]}).references(:publication)
  end

  def self.done(user)
    includes(:publication).where({publications: {user_id: user.id}}).where.not({answer: [nil, ""]}).references(:publication)
  end

  def get_status
    if status == 0 || status.nil?
      "Pendiente"
    else
      "Respuesta"
    end
  end

end
