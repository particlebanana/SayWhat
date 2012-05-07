require 'spec_helper'
require 'cgi'

describe Grant do
  before do
    @group = FactoryGirl.create(:group)
    @user = FactoryGirl.create(:user)
    @sponsor = FactoryGirl.create(:user, { email: 'sponsor@test.com', group: @group, role: 'adult sponsor' })
    @project = FactoryGirl.create(:project, { group: @group })
    @grant = FactoryGirl.create(:grant, { member: @user, project: @project })
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

  describe "notify_sponsor_of_application" do
    before do
      @grant.notify_sponsor_of_application('http://test.com', @user)
      @notifications = Notification.find_all(@sponsor.id)
    end

    it "should queue a NotifySponsorGrantJob" do
      NotifySponsorGrantJob.should have_queued('http://test.com', @user.id, @grant.id)
    end
  end

  describe "notify_admin_of_application" do
    before do
      @admin = FactoryGirl.create(:user, { email: "admin@test.com", role: "admin" } )
      @grant.notify_admin_of_application
    end

    it "should queue a NotifyAdminGrantJob" do
      NotifyAdminGrantJob.should have_queued(@grant.id)
    end
  end

  describe "approve" do
    before do
      @status = @grant.approve
      @notifications = Notification.find_all(@sponsor.id)
    end

    it "should return true" do
      @status.should == true
    end

    it "should set the status to approved" do
      @grant.reload.status.should == "approved"
    end

    it "should queue a ManageGrantApplicationJob" do
      ManageGrantApplicationJob.should have_queued(@grant.id, 'approve')
    end
  end

  describe "deny" do
    context "with reason" do
      before do
        @reason = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants'].first
        @status = @grant.deny(@reason)
        @notifications = Notification.find_all(@sponsor.id)
      end

      it "should return true" do
        @status.should == true
      end

      it "should destroy self" do
        Grant.where(id: @grant.id).count.should == 0
      end

      it "should queue a ManageGrantApplicationJob" do
        ManageGrantApplicationJob.should have_queued(@grant.id, 'deny', @reason['email_text'])
      end
    end

    context "without reason" do
      before { @status = @grant.deny('') }

      subject { @response }
      it { should be_false }
    end
  end
end