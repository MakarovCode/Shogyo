class VideoUploader < CarrierWave::Uploader::Base
  include CarrierWave::Video
  # include CarrierWave::Video::Thumbnailer

  #process encode_video: [:mp4, callbacks: { after_transcode: :set_success } ]

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(mp4 mov avi mkv 3gp mpg mpeg)
  end


  # version :thumb do
  #   process thumbnail: [{format: 'png', quality: 10, size: 192, strip: true, logger: Rails.logger}]
  #   def full_filename for_file
  #     png_name for_file, version_name
  #   end
  # end

  def png_name for_file, version_name
    %Q{#{version_name}_#{for_file.chomp(File.extname(for_file))}.png}
  end
end
