require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminSponsorsController do

  describe "#index" do
    before do
      group = FactoryGirl.create(:group)
      FactoryGirl.create(:user, {group: group})
      admin = FactoryGirl.create(:user, {email: "admin@test.com", role: "admin"})
      sign_in admin
      get :index, { id: group.id }
    end
    
    it "should return an array of User objects" do
      assigns[:members].count.should == 1
    end
    
    it "should not render a layout" do
      response.should_not render_template('layouts/admin')
    end
  end
  
  describe "#update" do
    before do
      @group = FactoryGirl.create(:group)
      @sponsor = FactoryGirl.create(:user, {email: "sponsor@test.com", role: "adult sponsor", group: @group})
      @member = FactoryGirl.create(:user, {email: "member@test.com", group: @group})
      admin = FactoryGirl.create(:user, {email: "admin@test.com", role: "admin"})
      sign_in admin
    end
    
    context "successfully" do
      before { put :update, {id: @group.id, user: @member.id} }
      
      it "should change @member role" do
        @member.reload.role.should == "adult sponsor"
      end
      
      it "should change @sponsor role" do
        @sponsor.reload.role.should == "member"
      end
      
      it "should redirect to groups#index" do
        response.should redirect_to("/admin/groups/#{@group.id}")
      end
      
      it "should have a success message" do
        flash[:notice].should =~ /sponsor updated/i
      end
    end
    
    context "missing parameter" do
      before { put :update, {id: @group.id} }
      
      it "should NOT change @member role" do
        @member.reload.role.should_not == "adult sponsor"
      end
      
      it "should NOT change @sponsor role" do
        @sponsor.reload.role.should_not == "member"
      end
      
      it "should redirect to groups#index" do
        response.should redirect_to("/admin/groups/#{@group.id}")
      end
      
      it "should have an error message" do
        flash[:alert].should =~ /select a valid user/i
      end
    end
  end
end