class Achivement < ApplicationRecord

  has_many :user_achivements
  has_many :users, through: :user_achivements

  mount_uploader :icon, LogoUploader

  def get_kind
    if self.kind == 1
      "bronce"
    elsif self.kind == 2
      "plata"
    else
      "oro"
    end
  end

end
