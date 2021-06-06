class UserConsultQuestionVisit < ApplicationRecord
  belongs_to :user
  belongs_to :consult_question
end
