# encoding: utf-8
class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"

    if model.class.to_s.underscore == "rennder_image"
      "uploads/#{model.rennder_texture.rennder.class.to_s.underscore}/source/#{model.rennder_texture.rennder.id}"
      # "uploads/#{model.rennder.class.to_s.underscore}/source/#{model.rennder.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
