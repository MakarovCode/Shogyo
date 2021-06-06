class Country < ApplicationRecord
  has_many :departments

  mount_uploader :flag, LogoUploader
end
