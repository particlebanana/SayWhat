raw_config = File.read(Rails.root.to_s + "/config/theme.yml")
THEME = YAML.load(raw_config)

Haml::Template::options[:format] = :html5
Sass::Plugin.options[:template_location]  = (Rails.root + 'app' + 'themes' + THEME['theme'] + THEME['stylesheets']).to_s
Sass::Plugin.options[:css_location]       = (Rails.root + 'public' + 'stylesheets').to_s
