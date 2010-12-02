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

def build_group_request
  request = {
    :group => {
      :display_name => "Han Shot First",
      :city => "Mos Eisley",
      :organization => "Free Greedo",
      :user => {
        :first_name => "Luke",
        :last_name => "Skywalker",
        :email => "luke.skywalker@gmail.com"
      }
    }
  }
end

def set_status_and_role(status, role)
  @user.status = status
  @user.role = role
end

def build_group_with_admin
  @group = Factory.build(:group)
  @admin = Factory.build(:user)
  @admin.status = "active"
  @admin.role = "adult sponsor"
  @group.users << @admin  
  @admin.save
  @group.save
end

def login_admin
  @admin = Factory.create(:admin)
  sign_in @admin
end

def build_project
  @group = Factory.create(:group)
  @user = Factory.build(:user)
  set_status_and_role("active", "member")
  @group.users << @user
  @user.save
  @project = Factory.build(:project)
  @group.projects << @project
  @project.save
  @group.save
end