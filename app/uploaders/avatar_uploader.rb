# encoding: utf-8
require 'carrierwave/processing/mini_magick'
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end
  
  def default_url
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end
  
  version :thumb do
    process :resize_to_fill => [25, 25]
  end
  
  version :small do
    process :resize_to_fill => [80, 80]
  end

  # Add a white list of extensions which are allowed to be uploaded.
   def extension_white_list
     %w(jpg jpeg gif png)
   end

end
