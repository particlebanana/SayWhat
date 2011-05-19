require 'rubygems'
require 'spork'
    
Spork.prefork do
  
  ENV["RAILS_ENV"] ||= 'test'
    require File.expand_path("../../config/environment", __FILE__)
    require 'rspec/rails'
    require 'remarkable/active_model'
    require 'remarkable/mongoid'
    require 'shoulda'
    require 'factory_girl_rails'
    require 'carrierwave/test/matchers'
    
    # Requires supporting files with custom matchers and macros, etc,
    # in ./support/ and its subdirectories.
    Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

    RSpec.configure do |config|
      config.mock_with :rspec

      config.before :each do
        Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
      end
      
      ### Part of a Spork hack. See http://bit.ly/arY19y
      # Emulate initializer set_clear_dependencies_hook in 
      # railties/lib/rails/application/bootstrap.rb
      ActiveSupport::Dependencies.clear

    end
  
end

Spork.each_run do

end