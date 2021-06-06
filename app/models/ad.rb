class Ad < ApplicationRecord
  belongs_to :client

  mount_uploader :image, AdUploader

  validates :image, file_size: { less_than_or_equal_to: 2.megabytes },
                     file_content_type: { allow: ['image/jpeg', 'image/png'] }
end
