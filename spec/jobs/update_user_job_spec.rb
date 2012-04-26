require 'spec_helper'

describe UpdateUserJob do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "#perform" do    
    before do
      UpdateUserJob.perform(@user.id)
    end

    it "should delete the old object key" do
      WebMock.should have_requested(:delete, "http://localhost:7979/object/user:#{@user.id}")
    end

    it "should generate a new object key" do
      WebMock.should have_requested(:post, "http://localhost:7979/object")
    end
  end
end