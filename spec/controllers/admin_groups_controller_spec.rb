require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminGroupsController do
  before(:each) do
    admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
    sign_in admin
  end
  
  describe "#index" do
    before do
      Factory.create(:group)
      get :index
    end
    
    it "should return an array of Group objects" do
      assigns[:groups].count.should == 1
      assigns[:groups].is_a? Array
    end
    
    it "should render the index template" do
      response.should render_template('groups/index')      
    end
  end
 
  describe "#show" do
    before do
      group = Factory.create(:group)
      Factory.create(:user, {group: group, role: 'adult sponsor'})
      get :show, id: group.id
    end
    
    it "should return a Group object" do
      assigns[:group].is_a? Group
    end
    
    it "should assign @sponsor" do
      assigns[:sponsor].is_a? User
    end
    
    it "should render the show template" do
      response.should render_template('groups/show')
    end
  end
   
  describe "#update" do
    before do
      @group = Factory.create(:group)
      Factory.create(:user, {group: @group, role: 'adult sponsor'})
    end
    
    context "with valid input" do
      before { put :update, {id: @group.id, group: { display_name: "Rebel Alliance" }} }
      
      subject{ @group.reload }
      its(:display_name) { should == "Rebel Alliance" }
      its(:name) { should == "rebel alliance" }
    
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
end