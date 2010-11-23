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
  
  describe "approve a pending membership request" do
    before(:each) do
      build_group_with_admin
      @user = Factory.build(:user_input, :email => "billy.bob@gmail.com")
      set_status_and_role("pending", "pending")
      @user.save
      @group.users << @user
      @group.save
    end
    
    it "should change the users status to setup" do
      sign_in @admin
      put :approve_pending_membership, {:id => @user.id.to_s}
      @user = User.find(@user.id.to_s)
      @user.status.should == "setup"
    end
    
    it "should change the users role to member" do
      sign_in @admin
      put :approve_pending_membership, {:id => @user.id.to_s}
      @user = User.find(@user.id.to_s)
      @user.role.should == "member"
    end
    
    it "should send the new member an email with their setup link" do
      put :approve_pending_membership, {:id => @user.id.to_s}
      ActionMailer::Base.deliveries.last.to.should == [@user.email]
    end
    
  end
  
  describe "setup a member account" do
    before(:each) do
      build_group_with_admin
      @user = Factory.build(:user_input, :email => "billy.bob@gmail.com")
      set_status_and_role("setup", "member")
      @user.save!
      @group.users << @user
      @group.save!
    end
    
    it "should change a members password" do
      sign_in @user
      put :create_member, {:id => @user.id.to_s, :user => {:password => "test123", :password_confirmation => "test123"}}
      response.should be_redirect
    end
    
    it "should reset the members token" do      
      sign_in @user
      token = @user.authentication_token
      put :create_member, {:id => @user.id.to_s, :user => {:password => "test123", :password_confirmation => "test123"}}
      response.should be_redirect
      @user = User.find(@user.id.to_s)
      @user.authentication_token.should_not == token
    end
    
  end

end