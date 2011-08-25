require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminGrantsController do
  
  describe "#index" do
    before do
      @grant = Factory.create(:minigrant, :status => true)
      login_admin
    end
    
    it "should list all the active grants" do
      get :index
      assigns[:grants].first.group_name.should == @grant.group_name
      assigns[:grants].first.adult_name.should == @grant.adult_name
    end
  end
  
  describe "#show" do
    before do
      @grant = Factory.create(:minigrant, :status => true)
      login_admin
    end
    
    it "should find the grant by id" do
      get :show, :id => @grant.id
      assigns[:grant].should_not be_nil
      assigns[:grant].group_name.should == @grant.group_name
      assigns[:grant].adult_name.should == @grant.adult_name
    end
  end
   
  describe "#destroy" do
    before(:each) do
      @grant = Factory.create(:minigrant, :status => false)
      login_admin
    end

    context "successfully" do
      before(:each) { do_destroy_grant(id: "#{@grant.id.to_s}", reason: "curriculum")}

      subject{ response }
      it { should redirect_to('/admin/grants/pending') }
      it "should destroy the application" do
        Grant.where(_id: "#{@grant.id}").first.should == nil
      end

      subject{ ActionMailer::Base.deliveries.last }
      its(:subject) { should == "SayWhat! Mini-Grant Has Been Denied" }
      its(:to) { should == ["han.solo@gmail.com"] }  
    end

    context "un-successfully" do
      before(:each) { do_destroy_grant(id: "#{@grant.id.to_s}", reason: "") }

      subject { response }
      it { should redirect_to("/admin/grants/#{@grant.id}/edit") }
    end
  end
end