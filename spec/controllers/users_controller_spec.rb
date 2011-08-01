require 'spec_helper'

describe UsersController do
    
  describe "setup a new group" do
    before(:each) do
      @group = Factory.create(:group)
      @user = Factory.build(:user)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
      @user.save!
      sign_in @user
    end
    
    describe "#create_sponsor" do
      it "should change a sponsor's password" do
        put :create_sponsor, {:id => @user.id.to_s, :user => {:password => "test123", :password_confirmation => "test123"}}
        response.should redirect_to(:controller => :groups, :action => :setup_permalink)
      end
      
      it "should require password to be entered" do
        put :create_sponsor, {:id => @user.id.to_s, :user => {:password => "", :password_confirmation => ""}}
        response.should redirect_to("/setup/sponsor")
      end
    
      it "should reset the sponsor's token" do
        token = @user.authentication_token
        put :create_sponsor, {:id => @user.id.to_s, :user => {:password => "test123", :password_confirmation => "test123"}}
        response.should be_redirect
        @user.reload.authentication_token.should_not == token
      end
    end
      
  end
  
  describe "edit a user's profile" do
    before(:each) do
      @user = Factory.build(:user)
      set_status_and_role("active", "adult sponsor")
      @user.save
      sign_in @user
    end
    
    describe "#update" do
      it "should change the user's name" do
        put :update, {:id => @user.id.to_s, :user => {:first_name => "Jabba", :last_name => "The Hut"}}
        @user.reload.name.should == "Jabba The Hut"
      end
    
      it "should change the user's email" do
        put :update, {:id => @user.id.to_s, :user => {:email => "test@example.com"}}
        @user.reload.email.should == "test@example.com"
      end
    
      it "should populate the bio field" do
        put :update, {:id => @user.id.to_s, :user => {:bio => "This is an example bio"}}
        @user.reload.bio.should_not == nil
      end
    end
    
  end
  
  describe "approve a pending membership request" do
    before(:each) do
      build_group_with_admin
      @user = Factory.build(:user, :email => "billy.bob@gmail.com")
      set_status_and_role("pending", "pending")
      @group.users << @user
      @user.save
      @group.save
      @message = @admin.create_message_request_object(@user.name, @user.email, @user.id.to_s)
      sign_in @admin
    end
    
    describe "#approve_pending_membership" do
      it "should change the users status to active" do
        put :approve_pending_membership, {:id => @user.id.to_s, :message => @message.id.to_s}
        @user.reload.status.should == "active"
      end
    
      it "should change the users role to member" do
        put :approve_pending_membership, {:id => @user.id.to_s, :message => @message.id.to_s}
        @user.reload.role.should == "member"
      end
    
      it "should send the new member an email" do
        put :approve_pending_membership, {:id => @user.id.to_s, :message => @message.id.to_s}
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
    end
    
  end
  
  describe "manage a group youth sponsor" do
    before do
      build_group_with_admin
      sign_in @admin
    end
    
    describe "#choose_youth_sponsor" do
      it "should list all the active members who are not sponsors" do
        get :choose_youth_sponsor, :permalink => @group.permalink
        assigns[:members].count.should == 1
      end
    end
    
    describe "#assign_youth_sponsor" do
      it "should change the users status to youth sponsor" do
        @user.role.should == "member"
        put :assign_youth_sponsor, :permalink => @group.permalink, :user_id => @user.id.to_s
        response.should be_redirect
        @user.reload.role.should == "youth sponsor"
      end
      
      it "should send the member an email notification" do
        put :assign_youth_sponsor, :permalink => @group.permalink, :user_id => @user.id.to_s
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
    end
    
    describe "#revoke_youth_sponsor" do
      it "should change the users status to member" do
        @user.update_attributes!(:role => "youth sponsor")
        put :revoke_youth_sponsor, :permalink => @group.permalink, :user_id => @user.id.to_s
        response.should be_redirect
        @user.reload.role.should == "member"
      end
      
      it "should send the member an email notification" do
        @user.update_attributes!(:email => "revoked@gmail.com", :role => "member")
        put :revoke_youth_sponsor, :permalink => @group.permalink, :user_id => @user.id.to_s
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
    end
  end

end