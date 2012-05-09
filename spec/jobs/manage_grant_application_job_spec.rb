require 'spec_helper'

describe ManageGrantApplicationJob do
  before do
    @group = FactoryGirl.create(:group)
    @sponsor = FactoryGirl.create(:user, { email: 'sponsor@test.com', group: @group, role: 'adult sponsor' })
    @project = FactoryGirl.create(:project, { group: @group })
    @grant = FactoryGirl.create(:grant, { member: @sponsor, project: @project })

    stub_request(:get, "http://localhost:7979/timeline/group:#{@group.id}")
      .to_return(:body => {}, :headers => {'Content-Type' => 'application/json'})
  end

  describe "#perform" do    
    context "approve" do
      before do
        ManageGrantApplicationJob.perform(@grant.id, "approve")
        @grant_body = {"data"=>[
          "{\"type\":\"message\",\"message\":\"#{@project.display_name} has been awarded a mini-grant!\"}"],
          "objects"=>["{\"group\":\"group:#{@group.id}\",\"project\":\"project:#{@project.id}\"}"],
          "timelines"=>["[\"group:#{@group.id}\",\"project:#{@project.id}\"]"],
          "key"=>["project:#{@project.id}:grant:#{@grant.id}:approved"]}
      end

      it "should create a notification for the group sponsor" do
        notifications = Notification.find_all(@sponsor.id)
        notifications.length.should == 1
        notifications[0].text.should == "Your grant application has been approved"
      end

      it "should publish to group and project timelines" do
        WebMock.should have_requested(:post, /http:\/\/localhost:7979\/event[?a-zA-Z0-9=&_]*/)
        .with{|req| CGI::parse(req.body) == @grant_body }
      end

      it "should send the group sponsor an email" do
        ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
      end
    end

    context "deny" do
      before do
        ManageGrantApplicationJob.perform(@grant.id, "deny", "test denied text")
      end

      it "should create a notification for the group sponsor" do
        notifications = Notification.find_all(@sponsor.id)
        notifications.length.should == 1
        notifications[0].text.should == "Your grant application has been denied"
      end

      it "should send the group sponsor an email" do
        ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
      end
    end

  end
end