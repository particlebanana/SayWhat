require 'rack/mime'

raw_config = File.read(Rails.root.to_s + "/config/config.yml")
CONFIG = YAML.load(raw_config)

Haml::Template::options[:format] = :html5
Sass::Plugin.options[:css_location]       = (Rails.root + 'public' + 'stylesheets').to_s
Sass::Plugin.options[:style] = :compressed