# encoding: utf-8

class OwnImageUploader < CarrierWave::Uploader::Base
  #    include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :high do
    process :resize_to_fill => [800,0]
  end

  version :mid do
    process :resize_to_fill => [640,0]
  end

  version :low do
    process :resize_to_fill => [300, 225]
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
