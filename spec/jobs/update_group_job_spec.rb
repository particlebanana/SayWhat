require 'spec_helper'

describe UpdateGroupJob do
  before do
    @group = FactoryGirl.create(:group)
  end

  describe "#perform" do    
    before do
      UpdateGroupJob.perform(@group.id)
    end

    it "should delete the old object key" do
      WebMock.should have_requested(:delete, "http://localhost:7979/object/group:#{@group.id}")
    end

    it "should generate a new object key" do
      WebMock.should have_requested(:post, "http://localhost:7979/object")
    end
  end
end