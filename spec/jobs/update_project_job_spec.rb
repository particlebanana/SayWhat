require 'spec_helper'

describe UpdateProjectJob do
  before do
    @group = FactoryGirl.create(:group)
    @project = FactoryGirl.create(:project, { group: @group })
  end

  describe "#perform" do    
    before do
      UpdateProjectJob.perform(@project.id)
    end

    it "should delete the old object key" do
      WebMock.should have_requested(:delete, "http://localhost:7979/object/project:#{@project.id}")
    end

    it "should generate a new object key" do
      WebMock.should have_requested(:post, "http://localhost:7979/object")
    end
  end
end