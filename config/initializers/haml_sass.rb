Haml::Template::options[:format] = :html5

Sass::Plugin.options[:template_location]  = (Rails.root + 'app' + 'styles').to_s
Sass::Plugin.options[:css_location]       = (Rails.root + 'public' + 'stylesheets').to_s