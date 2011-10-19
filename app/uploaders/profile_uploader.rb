require 'carrierwave/processing/mini_magick'
class ProfileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "/default/fallback/" + [version_name, "profile.jpg"].compact.join('_')
  end
  
  process resize_to_limit: [800, 800]
  
  version :thumb do
    process resize_to_fill: [50, 50]
  end

  version :medium_square do
    process resize_to_fill: [70, 70]
  end
  
  version :profile do
    process resize_to_limit: [270, 270]
  end

  # Add a white list of extensions which are allowed to be uploaded.
   def extension_white_list
     %w(jpg jpeg gif png)
   end

end
