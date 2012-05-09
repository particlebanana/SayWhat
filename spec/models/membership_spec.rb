require 'spec_helper'

describe Membership do
  before do
    # Objects
    @group = FactoryGirl.create(:group)
    @sponsor = FactoryGirl.create(:user, { email: 'sponsor@example.com', role: 'adult sponsor', group: @group })
    @user = FactoryGirl.create(:user)
    @membership = Membership.new( { group: @group, user: @user } )
  end

  before(:each) do
    ResqueSpec.reset!
  end
  
  context "Factory" do
    subject { @membership }
    it { should belong_to(:user) }
    it { should belong_to(:group) }
    
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:group_id) }
  end

  describe "#create_request" do
    context "successfully" do
      before do
        @response = @membership.create_request
      end

      it "should save membership request" do
        Membership.all.count.should == 1
      end

      it "should create a new Request for the group sponsor" do
        requests = Request.find_all(@sponsor.id)
        requests.length.should == 1
      end

      it "should queue a MembershipRequest event" do
        MembershipRequest.should have_queued(@membership.id)
      end

      it "should return true" do
        @response.should be_true
      end
    end

    context "error" do
      before do
        @membership.user_id = nil
        @response = @membership.create_request
      end

      it "should return false" do
        @response.should be_false
      end
    end
  end

  describe "#approve_membership" do
    before { @membership.create_request }

    context "successfully" do
      before  { @response = @membership.approve_membership }

      it "should set the users group_id" do
        @user.reload.group_id.should == @group.id
      end

      it "should queue a ManageGroupMembership approve event" do
        ManageGroupMembership.should have_queued(@user.id, @group.id, 'approve')
      end

      it "should return true" do
        @response.should be_true
      end
    end
  end

  describe "#deny_membership" do
    before do
      @membership.create_request
      @response = @membership.deny_membership
    end

    it "should queue a ManageGroupMembership deny event" do
      ManageGroupMembership.should have_queued(@user.id, @group.id, 'deny')
    end

    it "should return true" do
      @response.should be_true
    end
  end
end