# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

# Base Files
gem 'rails', '~>3.0.3'

# Sinatra Plugins
gem 'sinatra'
gem 'pony'


# Required System Gems
gem 'json'
gem 'haml'
gem 'sass'
gem 'nokogiri'
gem 'sanitize'

# Database
gem 'mongoid', '2.0.0.beta.19'
gem 'bson_ext'


# Authentication
gem 'devise', '~>1.1.3'
gem 'cancan'


# Application Wide
gem 'carrierwave', :git => "git://github.com/jnicklas/carrierwave.git"
gem 'mini_magick'


group :development, :test do
  gem 'rspec-rails', '2.0.0.beta.22'
  gem 'flutie'
end


group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'pickle'
  gem 'capybara', '0.4.0'
  gem 'rack-test'
  gem 'cucumber-rails', :git => "git://github.com/aslakhellesoy/cucumber-rails.git"
  gem 'cucumber'
  gem 'shoulda'
  gem 'launchy'
  gem 'remarkable'
  gem 'remarkable_mongoid'
  gem 'autotest'
  gem 'autotest-growl'
  gem 'spork', '0.8.4'
end

