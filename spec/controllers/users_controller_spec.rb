require 'spec_helper'

describe UsersController do
    
  describe "setup a new group" do
    
    it "should change a sponsor's password" do
      @group = Factory.create(:group)
      @user = Factory.build(:user_input)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
      
      sign_in @user
      put :create_sponsor, {:id => @user.id.to_s, :user => {:password => "test123", :password_confirmation => "test123"}}
      response.should be_redirect
    end
    
    it "should reset the sponsor's token" do
      @group = Factory.create(:group)
      @user = Factory.build(:user_input)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
      
      sign_in @user
      token = @user.authentication_token
      put :create_sponsor, {:id => @user.id.to_s, :user => {:password => "test123", :password_confirmation => "test123"}}
      response.should be_redirect
      @user = User.find(@user.id.to_s)
      @user.authentication_token.should_not == token
    end
      
  end
  
  describe "edit a user's profile" do
    before(:each) do
      @user = Factory.build(:user)
      set_status_and_role("active", "adult sponsor")
      @user.save
    end
    
    it "should change the user's name" do
      sign_in @user
      put :update, {:id => @user.id.to_s, :user => {:first_name => "Jabba", :last_name => "The Hut"}}
      @user = User.find(@user.id.to_s)
      @user.name.should == "Jabba The Hut"
    end
    
    it "should change the user's email" do
      sign_in @user
      put :update, {:id => @user.id.to_s, :user => {:email => "test@example.com"}}
      @user = User.find(@user.id.to_s)
      @user.email.should == "test@example.com"
    end
    
    it "should populate the bio field" do
      sign_in @user
      put :update, {:id => @user.id.to_s, :user => {:bio => "This is an example bio"}}
      @user = User.find(@user.id.to_s)
      @user.bio.should_not == nil
    end
    
  end

end