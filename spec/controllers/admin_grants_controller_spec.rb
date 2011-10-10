require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminGrantsController do
  before(:each) do
    admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
    sign_in admin
  end
    
  describe "#index" do
    before do
      Factory.create(:grant, {status: true})
      get :index
    end
    
    it "should return an array of Grant objects" do
      assigns[:grants].map {|e| e}.count.should == 1
      (assigns[:grants].map {|e| e}.is_a? Array).should be_true
    end
    
    it "should render the index template" do
      response.should render_template('admin_grants/index')      
    end
  end
  
  describe "#show" do
    before do
      grant = Factory.create(:grant)
      get :show, id: grant.id
    end
    
    it "should return a Grant object" do
      (assigns[:grant].is_a? Grant).should be_true
    end
    
    it "should render the show template" do
      response.should render_template('admin_grants/show')
    end
  end
  
  describe "#destroy" do
    before { @grant = Factory.create(:grant) }
    
    context "given a reason" do
      before { post :destroy, {id: @grant.id.to_s, reason: "curriculum"} }
      
      it "should remove the grant from the database" do
        Grant.where(id: @grant.id).first.should == nil
      end
      
      it "should have a success message" do
        flash[:notice].should =~ /application has been removed/i
      end
      
      it "should send the an email" do
        ActionMailer::Base.deliveries.last.subject.should =~ /grant has been denied/i
      end
    end
    
    context "without reason" do
      before { post :destroy, {id: @grant.id.to_s} }
      
      it "should redirect to requests" do
        response.should redirect_to("/admin/grants/#{@grant.id}")
      end
      
      it "should have an error message" do
        flash[:alert].should =~ /error denying grant/i
      end
    end
  end
end