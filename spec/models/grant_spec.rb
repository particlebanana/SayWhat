require 'spec_helper'

describe Grant do
  before do
    @group = Factory.create(:group)
    @user = Factory.create(:user)
    @sponsor = Factory.create(:user, { email: 'sponsor@test.com', group: @group, role: 'adult sponsor' })
    @project = Factory.create(:project, { group: @group })
    @grant = Factory.create(:grant, { member: @user, project: @project })
  end

  context "Factory" do
    subject { @grant }
    it { should belong_to(:project) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:member) }
    it { should validate_presence_of(:planning_team) }
    it { should validate_presence_of(:serviced) }
    it { should validate_presence_of(:goals) }
    it { should validate_presence_of(:funds_use) }
    it { should validate_presence_of(:partnerships) }
    it { should validate_presence_of(:resources) }
  end

  describe "notify_sponsor" do
    before do
      @grant.notify_sponsor('http://test.com', @user)
      @notifications = Notification.find(@sponsor.id)
    end

    it "should send group sponsor an email" do
      ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
    end

    it "should create a new notification" do
      @notifications.count.should == 1
    end
  end
end