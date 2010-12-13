require 'spec_helper'

describe GroupsController do
  
  describe "request a group" do
    
    describe "#create" do    
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
    
  end
    
  describe "approve a pending_group" do
    before do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user_input)
      set_status_and_role("pending", "pending")
      @group.users << @user
      @user.save!
      login_admin
    end
    
    describe "#approve_group" do
      it "should change a group's status to active" do
        put :approve_group, {:group_id => @group.id.to_s}
        @group.reload.status.should == "active"
      end
    
      it "should set the first user's role to adult sponsor" do
        put :approve_group, {:group_id => @group.id.to_s}
        @group.reload.users.first.role.should == "adult sponsor"
      end
    
      it "should set the adult sponsor's status to setup" do
        put :approve_group, {:group_id => @group.id.to_s}
        @group.reload.users.first.status.should == "setup"
      end
    
      it "should send the adult sponsor an email alert that their group has been approved" do
        put :approve_group, {:group_id => @group.id.to_s}
        ActionMailer::Base.deliveries.last.to.should == [@group.users.first.email]
      end
    end
  end
  
  describe "setup" do
    
    describe "#setup" do
      before do
        @group = Factory.create(:setup_group)
        @user = Factory.build(:user_input)
        set_status_and_role("setup", "adult sponsor")
        @group.users << @user
        @user.save!
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
    
    describe "#set_permalink" do
      before do
        @group = Factory.create(:setup_group)
        @user = Factory.build(:user_input)
        set_status_and_role("setup", "adult sponsor")
        @group.users << @user
        @user.save!
        @group.save!
        sign_in @user
      end
        
      it "should set a group's permalink" do
        put :set_permalink, {:group_id => @group.id.to_s, :group => {:permalink => "test"}}
        @group.reload.permalink.should == "test"
      end
    
      it "should escape a group's permalink" do
        put :set_permalink, {:group_id => @group.id.to_s, :group => {:permalink => "this is a test"}}
        @group.reload.permalink.should == "this+is+a+test"
      end
    
      it "should set a user's status to active" do
        put :set_permalink, {:group_id => @group.id.to_s, :group => {:permalink => "test"}}
        @user.reload.status.should == "active"
      end
    
      it "should send the adult sponsor an email notice with the group's permalink" do
        put :set_permalink, {:group_id => @group.id.to_s, :group => {:permalink => "test"}}
        ActionMailer::Base.deliveries.last.to.should == [@group.reload.users.first.email]
      end
    end
  end
  
  describe "edit group" do
    before(:each) do
      build_group_with_admin
      @user = seed_additional_group
    end
    
    describe "#edit" do
      it "should assign :adult_sponsor" do
        sign_in @admin
        get :edit, :permalink => @group.permalink
        assigns[:adult_sponsor].name.should == "Han Solo"
      end
      
      it "should not allow a member of another group to edit" do
        sign_in @user
        get :edit, :permalink => @group.permalink
        response.should be_redirect
      end
    end
    
    describe "#update" do
      it "should update a group with new values" do
        sign_in @admin
        put :update, {:permalink => @group.permalink, :group => {:display_name => "Rebel Alliance"}}
        @group.reload.display_name.should == "Rebel Alliance"
        @group.reload.name.should == "rebel alliance"
      end
      
      it "should not allow anyone to update except the group admins" do
        sign_in @user
        put :update, {:permalink => @group.permalink, :group => {:display_name => "Rebel Alliance"}}
        response.should redirect_to("/")
      end
    end
  end
  
  describe "#index" do
    before(:each) do
      build_group_with_admin
      seed_additional_group
    end
    
    it "should list all the groups in the system" do
      get :index
      assigns[:groups].count.should == 2
    end
    
    it "should render the groups index" do
      get :index
      response.should render_template('groups/index')
    end
  end
  
  describe "request group membership" do
    before(:each) do
      build_group_with_admin
      @user = seed_additional_group
    end
    
    describe "#create_membership_request" do
      it "should allow a user to request to join a group" do
        put :create_membership_request, {:permalink => @group.permalink, :user => {:first_name => "Bobba", :last_name => "Fett", :email => "bobba.fett@gmail.com"}}
        @group.reload.users.last.email.should == "bobba.fett@gmail.com"
        @group.reload.users.last.status.should == "pending"
        @group.reload.users.last.role.should == "pending"
      end
    
      it "should enforce user validations" do
        put :create_membership_request, {:permalink => @group.permalink, :user => {:first_name => "Bobba", :last_name => "Fett", :email => "member@gmail.com"}}
        response.should render_template('groups/request_membership')
      end
    
      it "should send the user a success email notice" do
        put :create_membership_request, {:permalink => @group.permalink, :user => {:first_name => "Bobba", :last_name => "Fett", :email => "bobba.fett@gmail.com"}}
        emails = ActionMailer::Base.deliveries
        emails.include?(["bobba.fett@gmail.com"])
      end
    
      it "should send group sponsor an membership notification" do
        put :create_membership_request, {:permalink => @group.permalink, :user => {:first_name => "Bobba", :last_name => "Fett", :email => "bobba.fett@gmail.com"}}
        ActionMailer::Base.deliveries.last.to.should == [@group.reload.users.adult_sponsor.first.email]
      end
    end
    
    describe "#pending_membership_request" do
      it "should allow a group adult sponsor to see all the pending members" do
        sign_in @admin
        get :pending_membership_requests, :permalink => @group.permalink
        response.should render_template("groups/pending_membership_requests")
      end
      
      it "should not allow a member of another group to view pending members" do
        sign_in @user
        get :pending_membership_requests, :permalink => @group.permalink
        response.should redirect_to("/")
      end
    end
  end
  
  describe "#send_invite" do
    before do
      @group = Factory.create(:group)
      @user = Factory.build(:user)
      set_status_and_role("active", "adult sponsor")
      @group.users << @user
      @user.save!
      @group.save!
      sign_in @user
    end
    
    it "should allow a group member to invite someone by email" do
      post :send_invite, {:permalink => @group.permalink, :user => {:email => "bobba.fett@gmail.com"}}
      ActionMailer::Base.deliveries.last.to.should == ["bobba.fett@gmail.com"]
    end
    
  end

end