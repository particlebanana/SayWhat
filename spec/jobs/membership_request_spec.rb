require 'spec_helper'

describe MembershipRequest do
  before do
    @group = FactoryGirl.create(:group)
    @sponsor = FactoryGirl.create(:user, { email: 'sponsor@example.com', role: 'adult sponsor', group: @group })
    @user = FactoryGirl.create(:user, {group: @group})
    @membership = Membership.create( { group: @group, user: @user } )    
  end

  describe "#perform" do    
    before do
      MembershipRequest.perform(@membership.id)
    end

    it "should send the sponsor an email" do
      ActionMailer::Base.deliveries.last.to.should == [@sponsor.email]
    end
  end
end