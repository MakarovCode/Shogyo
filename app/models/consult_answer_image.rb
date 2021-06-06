class ConsultAnswerImage < ApplicationRecord
  belongs_to :consult_answer

  mount_uploader :source, OwnImageUploader
end
