require 'spec_helper'

describe Membership do
  before { @membership = Membership.new() }
  
  context "Factory" do
    subject { @membership }
    it { should belong_to(:user) }
    it { should belong_to(:group) }
    
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:group_id) }
  end

  describe "#publish" do
    before { @membership.publish }

    it "should publish to the group timeline" do
      timeline = $feed.timeline("group:#{@membership.group_id}")
      timeline["feed"].first["key"].should include("membership:#{@membership.user_id}:create")
    end
  end
end