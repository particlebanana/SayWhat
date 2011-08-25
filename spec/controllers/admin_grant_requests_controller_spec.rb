require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminGrantRequestsController do

  describe "#index" do
    before do
      @grant = Factory.create(:minigrant, :status => false)
      login_admin
    end
    
    it "should list all the pending grants" do
      get :index
      assigns[:grants].count.should == 1
      assigns[:grants].first.group_name.should == @grant.group_name
    end
  end
  
  describe "#edit" do
    before do
      @grant = Factory.create(:minigrant, :status => false)
      login_admin
    end
    
    it "should find the pending grant by id" do
      get :edit, :id => @grant.id
      assigns[:grant].group_name.should == @grant.group_name
      assigns[:grant].adult_name.should == @grant.adult_name
    end
  end
 
  describe "#update" do
    before(:each) do
      @grant = Factory.create(:minigrant, :status => false)
      login_admin
    end
    
    context "successfully" do
      before(:each) { do_update_grant(id: "#{@grant.id}") }
      
      subject { response }
      it { should redirect_to('/admin/grants') }
            
      it "should send the adult contact an email" do
        ActionMailer::Base.deliveries.last.subject.should == "SayWhat! Mini-Grant Has Been Approved"
      end
            
      subject{ @grant.reload }
      its(:status) { should == true }
    end
  end
end