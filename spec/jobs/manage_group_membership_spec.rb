require 'spec_helper'

describe ManageGroupMembership do
  before do
    @group = FactoryGirl.create(:group)
    @sponsor = FactoryGirl.create(:user, { email: 'sponsor@example.com', role: 'adult sponsor', group: @group })
    @user = FactoryGirl.create(:user, {group: @group})

    data = {"feed"=>[
      {"data"=>{
        "type"=>"message", "message"=>"#{@user.name} joined the group"}, 
        "objects"=>{"user"=>{
          "id"=>"#{@user.id}", "name"=>"#{@user.name}", "photo"=>"/default/fallback/thumb_profile.jpg"}
          }, 
          "timelines"=>["group:#{@group.id}"], "subevents"=>[], "key"=>"membership:#{@user.id}:create"}], 
          "count"=>-1, "next_page"=>nil}.to_json

    
    stub_request(:get,
      %r|http://localhost:7979/timeline[?a-zA-Z0-9=&_]*|)
      .to_return(:body => data,
            :headers => {'Content-Type' => 'application/json'})

    @user2 = FactoryGirl.create(:user, { email: 'user2@test.com', group: @group })
    @membership = Membership.create( { group: @group, user: @user } )
    MembershipRequest.perform(@membership.id)
  end

  describe "#perform" do    
    context "approve" do
      before do
        memberships = Membership.where(:user_id => @user.id)
        memberships.length.should == 1
        ManageGroupMembership.perform(@user.id, @group.id, 'approve')
      end

      it "should subscribe user to the group timeline" do
        WebMock.should have_requested(:post, "http://localhost:7979/subscription")
      end

      it "should publish to group timeline" do
        @response = $feed.timeline("group:#{@group.id}")
        @response["feed"][0]["data"]["message"].should == "#{@user.name} joined the group"
        @response["feed"][0]["timelines"][0].should == "group:#{@group.id}"
      end

      it "should create a notification for the requesting user" do
        notifications = Notification.find_all(@user.id)
        notifications.length.should == 1
        notifications[0].text.should == "You have been approved for group membership"
      end

      it "should create a notification for the other users" do
        notifications = Notification.find_all(@user2.id)
        notifications.length.should == 1
        notifications[0].text.should == "#{@user.name} has joined your group"
      end

      it "should not create a notification for the group sponsor" do
        notifications = Notification.find_all(@sponsor.id)
        notifications.length.should == 0
      end

      it "should remove the membership request" do
        memberships = Membership.where(:user_id => @user.id)
        memberships.length.should == 0
      end

      it "should send the new user an email" do
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
    end

    context "deny" do
      before do
        memberships = Membership.where(:user_id => @user.id)
        memberships.length.should == 1
        ManageGroupMembership.perform(@user.id, @group.id, 'deny')
      end

      it "should remove the membership record request for the sponsor" do
        memberships = Membership.where(:user_id => @user.id)
        memberships.length.should == 0
      end
    end
  end
end