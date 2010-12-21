require File.expand_path('../boot', __FILE__)

#require 'rails/all'
require 'mongoid/railtie'
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"  

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module SayWhat
  class Application < Rails::Application
    
    config.generators do |g|
      g.orm             :mongoid
      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
    
    #config.generators do |g|
    #  g.fixture_replacement :factory_girl, :dir => "spec/factories"
    #end
    
    config.encoding = "utf-8"
    
    config.middleware.use "ServeGridfsImage"
    config.middleware.use "ServeStaticThemeFiles"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    ### Part of a Spork hack. See http://bit.ly/arY19y
    if Rails.env.test?
      initializer :after => :initialize_dependency_mechanism do
        # Work around initializer in railties/lib/rails/application/bootstrap.rb
        ActiveSupport::Dependencies.mechanism = :load
      end
    end
    
  end
end
