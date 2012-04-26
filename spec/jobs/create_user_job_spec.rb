require 'spec_helper'

describe CreateUserJob do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "#perform" do    
    before do
      CreateUserJob.perform(@user.id)
    end

    it "should generate an object key" do
      WebMock.should have_requested(:post, "http://localhost:7979/object")
    end

    it "should subscribe user to the global timeline" do
      WebMock.should have_requested(:post, "http://localhost:7979/subscription")
    end
  end
end