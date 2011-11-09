require 'rack/mime'

raw_config = File.read(Rails.root.to_s + "/config/config.yml")
CONFIG = YAML.load(raw_config)