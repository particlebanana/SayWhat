require 'spec_helper'

describe GroupsController do
  
  describe "request a group" do
    request = {
      :group => {
        :name => "Han Shot First",
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
    
    it "should add a pending group" do  
      lambda {
        lambda {
          post :create, request
        }.should change(Group, "count").by(1)
      }.should change(User, "count").by(1)
    end
    
    it "should add an adult sponsor with status of pending" do
      post :create, request
      @group = Group.find(:first, :conditions => {:name => "Han Shot First"})
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
  
  describe "setup a new group" do
    before do
      @group = Factory.create(:group)
      @user = Factory.create(:setup_user)
      @group.users << @user
    end
    
    it "should login a user with a token" do
      get :setup, {:id => @group.id.to_s, :auth_token => @user.authentication_token}
      response.should be_success
    end
  
  end

end