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

def build_project_params
  project = {
    :permalink => @group.permalink,
    :project => {
      :display_name =>  "Build Death Star",
      :location => "Outer Space",
      :start_date => "11-11-2011",
      :end_date => "11-12-2011",
      :focus => "Alderaan",
      :audience => "People of Aldreaan...for a flash",
      :goal => "Destroy planets",
      :involves => "Stormtroopers, Sith Lords, Vader, A Big Laser",
      :description => "A Top Secret project"
    }
  }
end

def build_comment_params
  comment_params = {
    :permalink => @group.permalink, 
    :name => @project.name, 
    :comment_id => @comment.id.to_s,
    :comment => {
      :comment => "This is an updated comment"
    }
  }
end

def set_status_and_role(status, role)
  @user.status = status
  @user.role = role
end

def build_group_with_admin
  @group = Factory.build(:group)
  @admin = Factory.build(:user, :email => "admin@gmail.com")
  @admin.status = "active"
  @admin.role = "adult sponsor"
  @group.users << @admin  
  @admin.save
  @user = Factory.build(:user, :email => "member@gmail.com")
  @user.status = "active"
  @user.role = "member"
  @group.users << @user
  @user.save
  @group.save
end

def login_admin
  @admin = Factory.create(:admin)
  sign_in @admin
end

def build_project
  @project = Factory.build(:project)
  @group.projects << @project
  @project.save
  @group.save
end

def add_comment
  @comment = Factory.build(:comment)
  @comment.user = @user
  @project.comments << @comment
  @comment.save!
  @project.save!
end

def create_project_cache
  @project_cache = ProjectCache.new(
    :group_id => @group.id.to_s, 
    :project_id => @project.id.to_s,
    :group_name => @group.display_name, 
    :group_permalink => @group.name, 
    :project_name => @project.display_name, 
    :project_permalink => @project.name, 
    :focus => @project.focus, 
    :audience => @project.audience
  )
  @project_cache.group_id = @group.id.to_s
  @project_cache.project_id = @project.id.to_s
end

def seed_additional_group
  group = Factory.build(:group, :display_name => "Trade Federation", :permalink => "trade+federation")
  group.save!
  project = Factory.build(:project, :display_name => "Join the empire")
  group.projects << project
  project.save!
  user = Factory.build(:user, :email => "add_member@gmail.com")
  user.status = "active"
  user.role = "member"
  group.users << user
  user.save!
  group.save!
  user
end