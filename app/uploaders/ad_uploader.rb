# encoding: utf-8

class AdUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :wide_high do
    process :resize_to_fill => [1280,250]
  end

  version :wide_mid do
    process :resize_to_fill => [850,80]
  end

  version :wide_low do
    process :resize_to_fill => [264,80]
  end

  version :square do
    process :resize_to_fill => [640,640]
  end

  version :tall_high do
    process :resize_to_fill => [264, 0]
  end

  version :tall_mid do
    process :resize_to_fill => [80, 0]
  end

  version :mobile_cover do
    process :resize_to_fill => [480,856]
  end

  version :mobile_banner do
    process :resize_to_fill => [320,80]
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
