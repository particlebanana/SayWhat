require 'spec_helper'

describe NotifySponsorGrantJob do
  before do
    @group = FactoryGirl.create(:group)
    @user = FactoryGirl.create(:user, { email: 'sponsor@test.com', group: @group, role: 'adult sponsor' })
    @project = FactoryGirl.create(:project, { group: @group })
    @grant = FactoryGirl.create(:grant, { member: @user, project: @project })
    @admin1 = FactoryGirl.create(:user, { email: 'admin1@gmail.com', role: 'admin' } )
    @admin2 = FactoryGirl.create(:user, { email: 'admin2@gmail.com', role: 'admin' } )
  end

  describe "#perform" do    
    before do
      @res = NotifyAdminGrantJob.perform(@grant.id)
    end

    it "should send each admin an email" do
      size = ActionMailer::Base.deliveries.length
      ActionMailer::Base.deliveries[size-2].to.should == [@admin1.email]
      ActionMailer::Base.deliveries[size-1].to.should == [@admin2.email]
    end

    it "should create a notification for each admin" do
      notifications_1 = Notification.find_all(@admin1.id)
      notifications_2 = Notification.find_all(@admin2.id)
      notifications_1.length.should == 1
      notifications_2.length.should == 1
      notifications_1[0].text.should == "#{@group.display_name} has applied for a mini-grant"
      notifications_2[0].text.should == "#{@group.display_name} has applied for a mini-grant"
    end
  end
end