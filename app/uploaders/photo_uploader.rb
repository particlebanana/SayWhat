require 'carrierwave/processing/mini_magick'
class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_limit: [800, 800]

  version :small do
    process resize_to_limit: [70, 70]
  end

  version :index do
    process resize_to_fill: [170, 118]
  end

  version :medium do
    process resize_to_limit: [170, 118]
  end

  version :large do
    process resize_to_limit: [270, 270]
  end

  # Add a white list of extensions which are allowed to be uploaded.
   def extension_white_list
     %w(jpg jpeg gif png)
   end
end