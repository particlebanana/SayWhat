require 'rubygems'
    
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'carrierwave/test/matchers'
require 'database_cleaner'
    
# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
    
  config.before :each do
    DatabaseCleaner.start
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end  
end
