require 'rubygems'
    
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'remarkable/active_model'
require 'factory_girl_rails'
require 'carrierwave/test/matchers'
require 'database_cleaner'

require_relative 'factory.rb'
  
# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  
  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
    conn = Mongo::Connection.new("localhost", 27017).db("ChronologicTest")
    conn.collection_names.each do |cf|
      coll = conn.collection(cf)
      coll.drop() unless cf == 'system.indexes'
    end
  end
    
  config.before :each do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end  
end
