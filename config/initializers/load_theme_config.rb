require 'rack/mime'

raw_config = File.read(Rails.root.to_s + "/config/theme.yml")
THEME = YAML.load(raw_config)

Haml::Template::options[:format] = :html5
Sass::Plugin.options[:template_location]  = (Rails.root + 'app' + 'themes' + THEME['theme'] + THEME['stylesheets']).to_s
Sass::Plugin.options[:css_location]       = (Rails.root + 'public' + 'stylesheets').to_s

class ServeStaticThemeFiles
  
  def initialize(app)
    @app = app
  end

  PATH = File.join(Dir.pwd, "app", "themes", THEME['theme'])
  
  def call(env)
    path = env['PATH_INFO']
    if env["PATH_INFO"] =~ /^\/#{THEME['images']}\/(.+)$/
      image = path.split('/').last
      image_path = File.join(PATH, path)
      content = File.read(image_path)
      length = "".respond_to?(:bytesize) ? content.bytesize.to_s : content.size.to_s
      [200, {"Content-Type"   => Rack::Mime.mime_type(File.extname(image), 'text/plain'),
            'Content-Length' => length,
            'Cache-Control' => "public, max-age=#{60 * 60 * 24 * 365}",
            'Expires' => (Time.now + 1.hour).rfc2822}, [content]]
    else
      @app.call(env)
    end
  end
  
end