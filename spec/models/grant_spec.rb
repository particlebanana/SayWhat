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

    it "should send group sponsor an email" do
      ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
    end

    it "should create a new notification" do
      @notifications.count.should == 1
    end
  end

  describe "notify_admin_of_application" do
    before do
      @admin = FactoryGirl.create(:user, { email: "admin@test.com", role: "admin" } )
      @grant.notify_admin_of_application
    end

    it "should send group sponsor an email" do
      ActionMailer::Base.deliveries.last.to.should == [@admin.email]
    end
  end

  describe "approve" do
    before do
      @status = @grant.approve
      @notifications = Notification.find_all(@sponsor.id)
      @grant_body = {"data"=>[
        "{\"type\":\"message\",\"message\":\"#{@project.display_name} has been awarded a mini-grant!\"}"],
        "objects"=>["{\"group\":\"group:#{@group.id}\",\"project\":\"project:#{@project.id}\"}"],
        "timelines"=>["[\"group:#{@group.id}\",\"project:#{@project.id}\"]"],
        "key"=>["project:#{@project.id}:grant:#{@grant.id}:approved"]}

    end

    it "should return true" do
      @status.should == true
    end

    it "should set the status to approved" do
      @grant.reload.status.should == "approved"
    end

    it "should send group sponsor an email" do
      ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
    end

    it "should create a new notification" do
      @notifications.count.should == 1
    end

    it "should publish to the group and project timeline" do
      WebMock.should have_requested(:post, /http:\/\/localhost:7979\/event[?a-zA-Z0-9=&_]*/)
      .with{|req| CGI::parse(req.body) == @grant_body }
    end
  end

  describe "deny" do
    context "with reason" do
      before do
        reason = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants'].first
        @status = @grant.deny(reason)
        @notifications = Notification.find_all(@sponsor.id)
      end

      it "should return true" do
        @status.should == true
      end

      it "should destroy self" do
        Grant.where(id: @grant.id).count.should == 0
      end

      it "should send group sponsor an email" do
        ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
      end

      it "should create a new notification" do
        @notifications.count.should == 1
      end
    end

    context "without reason" do
      before { @status = @grant.deny('') }

      subject { @response }
      it { should be_false }
    end
  end
end