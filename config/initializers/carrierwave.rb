CarrierWave.configure do |config|
  config.storage = :file
  config.delete_tmp_file_after_storage = true
end


if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end