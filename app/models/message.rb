class Message < ApplicationRecord
  #FIXME:
  #CAMBIAR EL UPLOADER POR UNO MÁS GENÉRICO
  mount_uploader :file, ImageUploader
end
