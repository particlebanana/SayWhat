require 'spec_helper'

describe NewGroupJob do
  before do
    @user = FactoryGirl.create(:user)
    @admin = FactoryGirl.create(:user, { email: 'admin@gmail.com', role: 'admin' } )
    @group = FactoryGirl.create(:group)
  end

  describe "#perform" do    
    before do
      NewGroupJob.perform(@group.id, @user.id)
      @user.reload
    end

    it "should add the user to the group" do
      @user.group_id.should == @group.id
    end

    it "should make the user an adult sponsor" do
      @user.role.should == "adult sponsor"
    end

    it "should send the requesting user an email" do
      ActionMailer::Base.deliveries.select { |e| e[:to].to_s == @user.email && e[:subject].to_s =~ /awaiting approval/i }.count.should > 0
    end
    
    it "should send the site admins an email" do
      ActionMailer::Base.deliveries.select { |e| e[:to].to_s == @admin.email && e[:subject].to_s =~ /you have a pending group request/i }.count.should > 0
    end
  end
end