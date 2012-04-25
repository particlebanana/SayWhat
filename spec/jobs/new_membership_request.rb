require 'spec_helper'

describe NewMembershipRequest do
  before do
    @group = FactoryGirl.create(:group)
    @sponsor = FactoryGirl.create(:user, { email: 'sponsor@example.com', role: 'adult sponsor', group: @group })
    @user = FactoryGirl.create(:user, {group: @group})
    @membership = Membership.create( { group: @group, user: @user } )
    @message = {
      text: I18n.t('notifications.membership.new_request'),
      link: "/users/#{@user.id}"
    }
    
  end

  describe "#perform" do    
    before do
      NewMembershipRequest.perform(@membership.id, @sponsor.id, @message[:text], @message[:link], @user.id)
    end

    it "should create a notification for the sponsor" do
      notifications = Notification.find_all(@sponsor.id)
      notifications.length.should == 1
      notifications[0].text.should == "You have a new group membership request"
      notifications[0].link.should == "/users/#{@user.id}"
    end

    it "should send the sponsor an email" do
      ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
    end
  end
end