require 'spec_helper'

describe ManageGroupRequestJob do
  before do
    @group = FactoryGirl.create(:group)
    @user = FactoryGirl.create(:user, {group: @group, role: "adult sponsor"})

    stub_request(:get, "http://localhost:7979/timeline/group:#{@group.id}")
      .to_return(:body => {}, :headers => {'Content-Type' => 'application/json'})
  end

  describe "#perform" do    
    context "approve" do
      before do
        ManageGroupRequestJob.perform(@user.id, @group.id, "http://localhost", "approve")
      end

      it "should generate an object key" do
        WebMock.should have_requested(:post, "http://localhost:7979/object")
      end

      it "should subscribe user to the group timeline" do
        WebMock.should have_requested(:post, "http://localhost:7979/subscription")
      end

      it "should publish to group timeline" do
        WebMock.should have_requested(:post, %r|http://localhost:7979/event[?a-zA-Z0-9=&_]*|)
      end

      it "should send the user an email" do
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
    end

    context "deny" do
      before do
        ManageGroupRequestJob.perform(@user.id, @group.id, "test", "deny")
        @user.reload
      end

      it "should remove the user from the group" do
        @user.group_id.should == nil
      end

      it "should make the user an member" do
        @user.role.should == "member"
      end

      it "should send the user an email" do
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
    end
  end
end