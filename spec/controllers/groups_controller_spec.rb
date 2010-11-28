require 'spec_helper'

describe GroupsController do
  
  describe "request a group" do
        
    it "should add a pending group" do 
      request = build_group_request 
      lambda {
        lambda {
          post :create, request
        }.should change(Group, "count").by(1)
      }.should change(User, "count").by(1)
    end
    
    it "should add an adult sponsor with status of pending" do 
      request = build_group_request     
      post :create, request
      @group = Group.find(:first, :conditions => {:display_name => "Han Shot First"})
      @group.users.first.status.should == "pending"
    end
    
    it "should send the pending sponsor an email alert" do
      @sponsor = Factory.create(:admin)
      request = build_group_request
      post :create, request
      ActionMailer::Base.deliveries.first.to.should == [request[:group][:user][:email]]
    end
    
    it "should send the admins an email alert" do
      @sponsor = Factory.create(:admin)
      request = build_group_request
      post :create, request
      ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
    end
    
  end
    
  describe "approve a pending_group" do
    before do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user_input)
      set_status_and_role("pending", "pending")
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
    
    it "should send the adult sponsor an email alert that their group has been approved" do
      put :approve_group, {:id => @group.id.to_s}
      ActionMailer::Base.deliveries.last.to.should == [@group.users.first.email]
    end
    
  end
  
  describe "setup" do
    before do
      @group = Factory.create(:setup_group)
      @user = Factory.build(:user_input)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
    end
    
    it "should login a user with a token" do
      get :setup, {:id => @group.id.to_s, :auth_token => @user.authentication_token}
      response.should be_success
    end
    
    it "should deny a user whos status is not setup" do
      @user.status = "active"
      @user.save
      get :setup, {:id => @group.id.to_s, :auth_token => @user.authentication_token}
      response.should be_redirect
    end
  end
    
  describe "set permalink" do
    before do
      @group = Factory.create(:setup_group)
      @user = Factory.build(:user_input)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
    end
        
    it "should set a group's permalink" do
      sign_in @user
      put :set_permalink, {:id => @group.id.to_s, :group => {:permalink => "test"}}
      @group = Group.find(@group.id.to_s)
      @group.permalink.should == "test"
    end
    
    it "should escape a group's permalink" do
      sign_in @user
      put :set_permalink, {:id => @group.id.to_s, :group => {:permalink => "this is a test"}}
      @group = Group.find(@group.id.to_s)
      @group.permalink.should == "this+is+a+test"
    end
    
    it "should set a user's status to active" do
      sign_in @user
      put :set_permalink, {:id => @group.id.to_s, :group => {:permalink => "test"}}
      @user = User.find(@user.id.to_s)
      @user.status.should == "active"
    end
    
    it "should send the adult sponsor an email notice with the group's permalink" do
      sign_in @user
      put :set_permalink, {:id => @group.id.to_s, :group => {:permalink => "test"}}
      @group = Group.find(@group.id.to_s)
      ActionMailer::Base.deliveries.last.to.should == [@group.users.first.email]
    end
  
  end
  
  describe "edit group" do
    before do
      @group = Factory.create(:group)
      @user = Factory.build(:user)
      set_status_and_role("active", "adult sponsor")
      @group.users << @user
    end
    
    it "should update a group with new values" do
      sign_in @user
      put :update, {:id => @group.id.to_s, :group => {:display_name => "Rebel Alliance"}}
      @group = Group.find(@group.id.to_s)
      @group.display_name.should == "Rebel Alliance"
      @group.name.should == "rebel alliance"
    end
    
  end
  
  describe "request group membership" do
    before do
      @group = Factory.create(:group)
      @user = Factory.build(:user)
      set_status_and_role("active", "adult sponsor")
      @group.users << @user
      @user.save
      @group.save
    end
    
    it "should allow a user to request to join a group" do
      put :create_membership_request, {:id => @group.id.to_s, :user => {:first_name => "Bobba", :last_name => "Fett", :email => "bobba.fett@gmail.com"}}
      @user = @group.users.last
      @user.email.should == "bobba.fett@gmail.com"
      @user.status.should == "pending"
      @user.role.should == "pending"
    end
    
    it "should enforce user validations" do
      user = Factory.build(:user, :first_name => "Bobba", :last_name => "Fett", :email => "bobba.fett@gmail.com", :status => "pending", :role => "pending")
      @group.users << user
      @group.save
      
      put :create_membership_request, {:id => @group.id.to_s, :user => {:first_name => "Bobba", :last_name => "Fett", :email => "bobba.fett@gmail.com"}}
      response.should render_template('groups/request_membership')
    end
    
    it "should send the user a success email notice" do
      put :create_membership_request, {:id => @group.id.to_s, :user => {:first_name => "Bobba", :last_name => "Fett", :email => "bobba.fett@gmail.com"}}
      emails = ActionMailer::Base.deliveries
      emails.include?(["bobba.fett@gmail.com"])
    end
    
    it "should send group sponsor an membership notification" do
      put :create_membership_request, {:id => @group.id.to_s, :user => {:first_name => "Bobba", :last_name => "Fett", :email => "bobba.fett@gmail.com"}}
      ActionMailer::Base.deliveries.last.to.should == [@group.users.adult_sponsor.first.email]
    end
    
  end
  
  describe "invite a member" do
    before do
      @group = Factory.create(:group)
      @user = Factory.build(:user)
      set_status_and_role("active", "adult sponsor")
      @group.users << @user
      @user.save
      @group.save
    end
    
    it "should allow a group member to invite someone by email" do
      sign_in @user
      post :send_invite, {:id => @group.id.to_s, :user => {:email => "bobba.fett@gmail.com"}}
      ActionMailer::Base.deliveries.last.to.should == ["bobba.fett@gmail.com"]
    end
    
  end

end