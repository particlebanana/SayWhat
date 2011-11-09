source 'http://rubygems.org'

# Base Files
gem 'rails', '~> 3.1.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1"
  gem 'coffee-rails', "~> 3.1"
  gem 'uglifier'
  gem 'therubyracer'
  gem 'execjs', :git => 'git://github.com/sstephenson/execjs.git'
end

# Database
gem 'mysql2', '~> 0.3.0'
gem 'mongo', '~> 1.4.0'
gem 'bson', '~> 1.4.0'
gem 'bson_ext', '~> 1.4.0'

# Authentication
gem 'devise', '~> 1.4.0'
gem 'cancan'

# Javascript
gem 'handlebars_assets', '~> 0.1.0'
gem 'plupload-rails', '~> 1.0.0'
gem 'jquery-rails'

# Deploy
gem 'capistrano'
gem 'unicorn'

# Helpers
gem 'json'
gem 'hashie', '~> 1.1.0'
gem 'haml'
gem 'nokogiri'
gem 'mini_magick'
gem 'sanitize'
gem 'escape_utils'
gem 'carrierwave', "~> 0.5.0"

# Chronologic Activity Feed
gem 'chronologic', :path => '/vagrant/chronologic'

# Sinatra Plugins
gem 'sinatra'
gem 'pony'

group :test do
  gem 'rspec', '~> 2.6.0'
  gem 'rspec-rails', '~> 2.6.0'
  gem 'remarkable_activemodel', '~> 4.0.0.alpha2'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 1.3.0'
  gem 'shoulda', '>= 3.0.0.beta'
  gem 'rack-test'
  gem 'spork', '> 0.9.0.rc'
end