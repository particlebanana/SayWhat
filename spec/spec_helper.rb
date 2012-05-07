require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'remarkable/active_model'
  require 'factory_girl_rails'
  require 'database_cleaner'
  require 'webmock/rspec'
  require 'rack/test'
  require 'shoulda'
  
  # Requires supporting files with custom matchers and macros, etc,
  # in ./support/ and its subdirectories.
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec

    config.before(:suite) do
      DatabaseCleaner[:active_record].strategy = :transaction
      conn = Mongo::Connection.new("localhost", 27017)
      conn.drop_database("ChronologicTest")
      conn.drop_database("saywhat_test")
    end
    
    config.before :each do
      DatabaseCleaner.start

      # Mocks
      WebMock.disable_net_connect!

      stub_http_request(:post,
        %r|http://localhost:7979/object[?a-zA-Z0-9=&_]*|)
        .to_return(:body => {}, :status => 201)

      stub_http_request(:post,
        %r|http://localhost:7979/subscription[?a-zA-Z0-9=&_]*|)
        .to_return(:body => {}, :status => 201)

      stub_http_request(:post,
      %r|http://localhost:7979/event[?a-zA-Z0-9=&_]*|)
      .to_return(:body => {}, :status => 201)

      stub_http_request(:post,
      %r|http://localhost:7979/publish[?a-zA-Z0-9=&_]*|)
      .to_return(:body => {}, :status => 201)

      stub_http_request(:delete,
      %r|http://localhost:7979/object[\/:?a-zA-Z0-9=&_]*|)
      .to_return(:status => 200, :body => "")

    end

    config.after(:each) do
      DatabaseCleaner.clean
    end  

    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end