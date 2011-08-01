# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

# Base Files
gem 'rails', '~> 3.0.3'
gem 'unicorn'

gem 'capistrano'

# Sinatra Plugins
gem 'sinatra'
gem 'pony'

# Required System Gems
gem 'json'
gem 'haml'
gem 'sass'
gem 'nokogiri'
gem 'sanitize'
gem 'escape_utils'

# Database
gem 'mongoid', '~> 2.0.0'
gem 'bson_ext', '~> 1.3'

# Authentication
gem 'devise', '~> 1.1.3'
gem 'cancan'

# Application Wide
gem 'carrierwave', '~> 0.5.3'
gem 'mini_magick'


group :development, :test do
  gem 'rspec-rails', '2.0.0.beta.22'
end


group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'pickle'
  gem 'capybara', '~> 1.0.0'
  gem 'rack-test'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'shoulda'
  gem 'launchy'
  gem 'remarkable'
  gem 'remarkable_mongoid'
  gem 'autotest'
  gem 'autotest-growl'
  gem 'spork', '0.8.4'
end

