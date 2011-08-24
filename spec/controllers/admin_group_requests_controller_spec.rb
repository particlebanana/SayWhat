require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminGroupRequestsController do

  describe "#index" do
    before do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user)
      set_status_and_role("pending", "pending")
      @user.group = @group
      @user.save!
      login_admin
    end
    
    it "should list all the pending group requests by date" do
      get :index
      assigns[:groups].count.should == 1
      assigns[:groups].first.display_name.should == "Han Shot First"
    end
  end
 
  describe "#show" do
    before do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user)
      set_status_and_role("pending", "pending")
      @user.group = @group
      @user.save!
      login_admin
    end
    
    it "should find the pending group by id" do
      get :show, :id => @group.id
      assigns[:group].should_not be_nil
      assigns[:group].display_name.should == "Han Shot First"
      assigns[:group].organization.should == "Free Greedo"
    end
  end
  
  describe "#approve" do
    before(:each) do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user)
      set_status_and_role("pending", "pending")
      @user.group = @group
      @user.save!
      login_admin
    end
    
    it "should change a group's status to active" do
      put :approve, {:id => @group.id}
      @group.reload.status.should == "active"
    end

    it "should set the first user's role to adult sponsor" do
      put :approve, {:id => @group.id}
      @group.reload.users.first.role.should == "adult sponsor"
    end

    it "should set the adult sponsor's status to active" do
      put :approve, {:id => @group.id}
      @group.reload.users.first.status.should == "active"
    end

    it "should send the adult sponsor an email alert that their group has been approved" do
      put :approve, {:id => @group.id}
      ActionMailer::Base.deliveries.last.subject.should == "Your group has been approved on SayWhat!"
    end
  end
end