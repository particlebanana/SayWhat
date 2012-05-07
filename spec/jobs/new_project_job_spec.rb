require 'spec_helper'

describe NewProjectJob do
  before do
    @group = FactoryGirl.create(:group)
    @project = FactoryGirl.create(:project, { group: @group })
  end

  describe "#perform" do    
    before do
      NewProjectJob.perform(@project.id)
    end

    it "should generate an object key" do
      WebMock.should have_requested(:post, "http://localhost:7979/object")
    end

    it "should publish to group timeline" do
      WebMock.should have_requested(:post, %r|http://localhost:7979/event[?a-zA-Z0-9=&_]*|)
    end
  end
end