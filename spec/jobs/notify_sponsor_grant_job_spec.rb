require 'spec_helper'

describe NotifySponsorGrantJob do
  before do
    @group = FactoryGirl.create(:group)
    @user = FactoryGirl.create(:user)
    @sponsor = FactoryGirl.create(:user, { email: 'sponsor@test.com', group: @group, role: 'adult sponsor' })
    @project = FactoryGirl.create(:project, { group: @group })
    @grant = FactoryGirl.create(:grant, { member: @user, project: @project })
  end

  describe "#perform" do    
    before do
      NotifySponsorGrantJob.perform("http://localhost", @user.id, @grant.id)
    end

    it "should send the sponsor an email" do
      ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
    end

    it "should create a notification for the sponsor" do
      notifications = Notification.find_all(@sponsor.id)
      notifications.length.should == 1
      notifications[0].text.should == "You have a grant application awaiting finalization"
      notifications[0].link.should == "/groups/#{@group.permalink}/projects/#{@project.id}/grants/#{@grant.id}/edit"
    end
  end
end