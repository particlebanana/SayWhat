require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminSponsorsController do

  describe "#index" do
    before do
      build_decaying_group
      login_admin
    end
    
    it "should pull a list of group members" do
      get :index, { id: @group.id }
      assigns[:members].count.should == 1
    end
  end

  describe "#update" do
    before(:each) do
      @user = build_decaying_group
      login_admin
    end
    
    context "admin to group member" do
      before(:each) { do_update_sponsor }
      
      subject { @captain_zissou.reload }
      its(:role) { should == "member" }
    end
    
    context "member to group sponsor" do
      before(:each) { do_update_sponsor }
            
      subject { @user.reload }
      its(:role) { should == "adult sponsor" }
    end
  end  
end