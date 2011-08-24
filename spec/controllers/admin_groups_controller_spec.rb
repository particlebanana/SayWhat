require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminGroupsController do

  describe "#index" do
    before do
      @group = Factory.create(:group)
      login_admin
    end
    
    it "should list all groups" do
      get :index
      assigns[:groups].count.should == 1
      assigns[:groups].first.display_name.should == @group.display_name
      assigns[:groups].first.organization.should == @group.organization
    end
  end
 
  describe "#show" do
    before do
      build_group_with_admin
      login_admin
    end
    
    it "should find the group by id" do
      get :show, :id => @group.id
      assigns[:group].should_not be_nil
      assigns[:group].display_name.should == @group.display_name
      assigns[:group].organization.should == @group.organization
    end
  end
   
  describe "#update" do
    before do
      build_group_with_admin
      login_admin
    end
    
    context "successfully" do
      before(:each) { do_update_group() }
      
      subject{ @group.reload }
      its(:display_name) { should == "Rebel Alliance" }
      its(:name) { should == "rebel alliance" }
    end
  end
  
  describe "#destroy" do
    before(:each) do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user)
      set_status_and_role("pending", "pending")
      @user.group = @group
      @user.save!
      login_admin
    end
    
    it "should fail if no reason is given" do
      post :destroy, {:id => @group.id}
      response.should redirect_to("/admin/group_requests/#{@group.id.to_s}")
    end
    
    it "should fail if reason is blank" do
      post :destroy, {:id => @group.id, :reason => ""}
      response.should redirect_to("/admin/group_requests/#{@group.id.to_s}")
    end
    
    it "should succeed if a reason is given" do
      post :destroy, {:id => @group.id, :reason => "age"}
      response.should redirect_to("/admin/group_requests")
    end
    
    it "should remove a group from the database" do
      post :destroy, {:id => @group.id, :reason => "organization"}
      Group.where(:id => @group.id).first.should == nil
    end
    
    it "should remove the user from the database" do
      post :destroy, {:id => @group.id, :reason => "missing"}
      User.where(:group_id => @group.id).first.should == nil
    end
    
    it "should send the adult sponsor an email alert that their group has been denied" do
      post :destroy, {:id => @group.id, :reason => "age"}
      ActionMailer::Base.deliveries.last.subject.should == "Your group has been denied on SayWhat!"
    end
  end
  
  describe "#resend" do
    before do
      @group = Factory.create(:pending_group, :status => "setup")
      @user = Factory.build(:user)
      set_status_and_role("setup", "admin")
      @user.group = @group
      @user.save!
      login_admin
    end
    
    context "approval email" do
      before(:each) { do_resend }
    
      subject{ ActionMailer::Base.deliveries.last }
      its(:subject) { should == "Your group has been approved on SayWhat!" }
      its(:to) { should == ["han.solo@gmail.com"] }
    end
  end
end