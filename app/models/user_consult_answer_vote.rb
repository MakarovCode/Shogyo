class UserConsultAnswerVote < ApplicationRecord
  belongs_to :user
  belongs_to :consult_answer
  
  def self.positives
    where points: 1
  end

  def self.negatives
    where points: -1
  end

  def value_name
    if self.points == 1
      "Positiva"
    elsif self.points == -1
      "Negativa"
    else
      "Neutra"
    end
  end

  def is_positive?
    self.points == 1
  end

  def is_negative?
    self.points == -1
  end
end
