require 'spec_helper'

describe SubscribeToGroupJob do
  before do
    @user = FactoryGirl.create(:user)
    @group = FactoryGirl.create(:group)
  end

  describe "#perform" do    
    before do
      SubscribeToGroupJob.perform(@user.id, @group.id)
    end

    it "should subscribe user to the group timeline" do
      WebMock.should have_requested(:post, "http://localhost:7979/subscription")
    end
  end
end