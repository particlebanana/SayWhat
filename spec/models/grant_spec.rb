require 'spec_helper'

describe Grant do
  context "Factory" do
    before do
      @user = Factory.create(:user)
      @group = Factory.create(:group)
      @project = Factory.create(:project, { group: @group })
      @grant = Factory.build(:grant)
      @grant.member = @user
      @grant.save!
    end

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
end