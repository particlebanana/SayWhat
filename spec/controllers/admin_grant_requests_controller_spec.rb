require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminGrantRequestsController do
  before(:each) do
    admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
    sign_in admin
  end
  
  describe "#index" do
    before do
      Factory.create(:grant)
      get :index
    end
    
    it "should return an array of Grant objects" do
      assigns[:grants].count.should == 1
      assigns[:grants].is_a? Array
    end
    
    it "should render the index template" do
      response.should render_template('admin_grant_requests/index')      
    end
  end
  
  describe "#edit" do
    before do
      grant = Factory.create(:grant)
      get :edit, id: grant.id.to_s
    end
    
    it "should return a Grant object" do
      assigns[:grant].is_a? Grant
    end
    
    it "should render the edit template" do
      response.should render_template('admin_grant_requests/edit')
    end
  end
  
  describe "#update" do
    before do
      @grant = Factory.create(:grant)
      put :update, id: @grant.id.to_s
    end
    
    it "should set the grant status to true" do
      @grant.reload.status.should == true
    end
    
    it "should redirect to grants index" do
      response.should redirect_to('/admin/grants')
    end
    
    it "should send an email" do
      ActionMailer::Base.deliveries.last.subject.should =~ /grant has been approved/i
    end
  end

  describe "#destroy" do
    before do
      grant = Factory.create(:grant)
      get :destroy, id: grant.id.to_s
    end
    
    it "should assign @reasons" do
      assigns[:reasons].size.should > 0
    end
    
    it "should not render a layout" do
      response.should_not render_template('layouts/admin')
    end
  end
end