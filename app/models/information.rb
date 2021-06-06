class Information < ApplicationRecord
  mount_uploader :logo, LogoUploader
  mount_uploader :small_logo, LogoUploader
  mount_uploader :meta_image, LogoUploader
  mount_uploader :about_us_image, LogoUploader
  mount_uploader :register_image, LogoUploader
  mount_uploader :login_image, LogoUploader
end
