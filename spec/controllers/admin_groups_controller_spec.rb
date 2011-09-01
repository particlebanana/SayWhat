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
  
    
      it "should redirect to #index" do
        response.should redirect_to('/admin/groups')
      end
      
      it "should have a success message" do
        flash[:notice].should =~ /updated successfully/i
      end
    end
    
    context "with invalid input" do
      before { put :update, {id: @group.id, group: { display_name: " " }} }
      
      subject{ @group.reload }
      its(:display_name) { should_not == ' ' }
    
      it "should redirect to #edit" do
        response.should redirect_to("/admin/groups/#{@group.id}")
      end
      
      it "should have an error message" do
        flash[:alert].should =~ /problem updating/i
      end
    end
  end
  
  describe "#destroy" do
    before do
      @group = Factory.create(:group)
      Factory.create(:user, {group: @group, role: 'adult sponsor'})
    end
    
    context "given a reason" do
      before { post :destroy, {id: @group.id, reason: "age"} }
      
      it "should remove the group from the database" do
        Group.where(id: @group.id).first.should == nil
      end
      
      it "should remove the sponsor account from the database" do
        User.where(group_id: @group.id).count.should == 0
      end
      
      it "should send the sponsor an email" do
        ActionMailer::Base.deliveries.last.subject.should =~ /group has been denied/i
      end
    end
    
    context "without reason" do
      before { post :destroy, {id: @group.id} }
      
      it "should redirect to requests" do
        response.should redirect_to("/admin/group_requests/#{@group.id}")
      end
      
      it "should have an error message" do
        flash[:alert].should =~ /error removing group/i
      end
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