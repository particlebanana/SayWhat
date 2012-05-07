require 'spec_helper'

describe AdminGrantRequestsController do
  before(:each) do
    admin = FactoryGirl.create(:user, {email: "admin@test.com", role: "admin"})
    sign_in admin
    group = FactoryGirl.create(:group)
    user = FactoryGirl.create(:user, { group: group, role: 'adult sponsor' })
    project = FactoryGirl.create(:project, { group: group })
    @grant = FactoryGirl.create(:grant, { member: user, project: project, status: 'completed' })
  end
  
  describe "#index" do
    before { get :index }
    
    it "should return an array of Grant objects" do
      assigns[:grants].count.should == 1
    end
    
    it "should render the index template" do
      response.should render_template('admin_grant_requests/index')      
    end
  end
  
  describe "#edit" do
    before { get :edit, id: @grant.id }
    
    it "should return a Grant object" do
      (assigns[:grant].is_a? Grant).should be_true
    end
    
    it "should render the edit template" do
      response.should render_template('admin_grant_requests/edit')
    end
  end
  
  describe "#update" do
    before { put :update, id: @grant.id }
    
    it "should set the grant status to approved" do
      @grant.reload.status.should == 'approved'
    end
    
    it "should redirect to grants index" do
      response.should redirect_to('/admin/grants')
    end
    
    it "should queue a ManageGrantApplicationJob" do
      ManageGrantApplicationJob.should have_queued(@grant.id, 'approve')
    end
  end
end