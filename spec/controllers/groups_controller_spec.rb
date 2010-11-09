require 'spec_helper'

describe GroupsController do
  
  describe "request a group" do
        
    it "should add a pending group" do  
      request = {
        :group => {
          :display_name => "Han Shot First",
          :city => "Mos Eisley",
          :organization => "Free Greedo",
          :user => {
            :first_name => "Luke",
            :last_name => "Skywalker",
            :username => "LukeSkywalker",
            :email => "luke.skywalker@gmail.com"
          }
        }
      }
      
      lambda {
        lambda {
          post :create, request
        }.should change(Group, "count").by(1)
      }.should change(User, "count").by(1)
    end
    
    it "should add an adult sponsor with status of pending" do
      request = {
        :group => {
          :display_name => "Han Shot First",
          :city => "Mos Eisley",
          :organization => "Free Greedo",
          :user => {
            :first_name => "Luke",
            :last_name => "Skywalker",
            :username => "LukeSkywalker",
            :email => "luke.skywalker@gmail.com"
          }
        }
      }
      
      post :create, request
      @group = Group.find(:first, :conditions => {:display_name => "Han Shot First"})
      @group.users.first.status.should == "pending"
    end
    
  end
    
  describe "approve a pending_group" do
    before do
      @group = Factory.create(:pending_group)
      @user = Factory.create(:pending_user)
      @group.users << @user
      login_admin
    end
    
    it "should change a group's status to active" do
      put :approve_group, {:id => @group.id.to_s}
      @group = Group.find(@group.id.to_s)
      @group.status.should == "active"
      
    end
    
    it "should set the first user's role to adult sponsor" do
      put :approve_group, {:id => @group.id.to_s}
      @group = Group.find(@group.id.to_s)
      @group.users.first.role.should == "adult sponsor"
    end
    
    it "should set the adult sponsor's status to setup" do
      put :approve_group, {:id => @group.id.to_s}
      @group = Group.find(@group.id.to_s)
      @group.users.first.status.should == "setup"
    end
    
  end
  
  describe "setup" do
    before do
      @group = Factory.create(:setup_group)
      @user = Factory.create(:setup_user)
      @group.users << @user
    end
    
    it "should login a user with a token" do
      get :setup, {:id => @group.id.to_s, :auth_token => @user.authentication_token}
      response.should be_success
    end
  end
    
  describe "set permalink" do
    before do
      @group = Factory.create(:setup_group)
      @user = Factory.create(:setup_user)
      @group.users << @user
    end
        
    it "should set a group's permalink" do
      sign_in @user
      put :set_permalink, {:id => @group.id.to_s, :group => {:permalink => "test"}}
      @group = Group.find(@group.id.to_s)
      @group.permalink.should == "test"
    end
    
    it "should set a user's status to active" do
      sign_in @user
      put :set_permalink, {:id => @group.id.to_s, :group => {:permalink => "test"}}
      @user = User.find(@user.id.to_s)
      @user.status.should == "active"
    end
    
    it "should destroy the users auth token" do
      sign_in @user
      put :set_permalink, {:id => @group.id.to_s, :group => {:permalink => "test"}}
      @user = User.find(@user.id.to_s)
      @user.authentication_token.should == nil
    end
  
  end

end