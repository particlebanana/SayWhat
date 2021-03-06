require 'spec_helper'

describe Membership do
  before do
    @group = FactoryGirl.create(:group)
    @sponsor = FactoryGirl.create(:user, { email: 'sponsor@example.com', role: 'adult sponsor', group: @group })
    @user = FactoryGirl.create(:user)
    @membership = Membership.new( { group: @group, user: @user } )
  end
  
  context "Factory" do
    subject { @membership }
    it { should belong_to(:user) }
    it { should belong_to(:group) }
    
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:group_id) }
  end

  describe "#create_request" do
    context "successfully" do
      before do
        @response = @membership.create_request
        @notifications = Notification.find_all(@sponsor.id)
        @request = Membership.where(group_id: @group.id, user_id: @user.id).first
        @notification = Notification.find_all(@sponsor.id).first
      end

      it "should save membership request" do
        Membership.all.count.should == 1
      end

      it "should create a notification for the group sponsor" do
        @notifications.count.should == 1
      end

      it "should add the notification id to the membership record" do
        @request.notification.should == @notification.id.to_s
      end

      it "should send the group sponsor an email" do
        ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
      end

      it "should return true" do
        @response.should be_true
      end
    end

    context "error" do
      before do
        @membership.user_id = nil
        @response = @membership.create_request
      end

      it "should return false" do
        @response.should be_false
      end
    end
  end

  describe "#approve_membership" do
    before { @membership.create_request }

    context "successfully" do
      before  { @response = @membership.approve_membership }

      it "should set the users group_id" do
        @user.reload.group_id.should == @group.id
      end

      it "should publish a message to the Group's timeline" do
        timeline = $feed.timeline("group:#{@group.id}")
        timeline["feed"].first["key"].should include("membership:#{@user.id}:create")
      end

      it "should destroy the membership record" do
        Membership.where(user_id: @user.id).count.should == 0
      end

      it "should send the new member an email" do
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end

      it "should return true" do
        @response.should be_true
      end
    end
  end

  describe "#deny_membership" do
    before do
      @membership.create_request
      @notification_count = Notification.find_all(@sponsor.id).count
      @membership_count = Membership.all.count
      @response = @membership.deny_membership
    end

    it "should remove sponsor notification" do
      Notification.find_all(@user.id).count.should == @notification_count - 1
    end

    it "should destory its self" do
      Membership.all.count.should == @membership_count - 1
    end

    it "should return true" do
      @response.should be_true
    end
  end
end