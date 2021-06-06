class ConsultQuestionImage < ApplicationRecord
  belongs_to :question

  mount_uploader :source, OwnImageUploader
end
