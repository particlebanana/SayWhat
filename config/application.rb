require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the default gems, the ones in the
# current environment and also include :assets gems if in development
# or test environments.
Bundler.require *Rails.groups(:assets) if defined?(Bundler)

module SayWhat
  class Application < Rails::Application
    
    generators = config.respond_to?(:app_generators) ? config.app_generators : config.generators
    generators.fixture_replacement :factory_girl, :dir => "spec/factories"
        
    config.encoding = "utf-8"
    
    config.middleware.use "ServeGridfsImage"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    # Enable the asset pipeline
    config.assets.enabled = true    
  end
end
