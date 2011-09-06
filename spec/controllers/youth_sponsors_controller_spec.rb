require 'spec_helper'

describe YouthSponsorsController do
  before do
    @group = Factory.create(:group)
    user = Factory.create(:user, {group: @group})
    sign_in user
  end
  
  describe "#index" do
    before do 
      Factory.create(:user, {email: 'member@test.com', role: 'adult sponsor'})
      get :index
    end
    
    it "should return all active group users with role of member" do
      assigns[:members].is_a? Array
      assigns[:members].count.should == 1 # only return member and not adult sponsor
    end
    
    it "should render index template" do
      response.should render_template('youth_sponsors/index')
    end
  end
  
  describe "#update" do
    before do 
      @user = Factory.create(:user, {email: 'member@test.com', role: 'member', group: @group})
    end
    
    context "sucessfully" do
      before { put :update, user_id: @user.id }
    
      it "should change user role to youth sponsor" do
        @user.reload.role.should == 'youth sponsor'
      end
    
      it "should set flash message" do
        flash[:notice].should =~ /sponsor updated/i
      end
    
      it "should send an email notification" do
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
      
      it "should redirect to groups edit" do
        response.should redirect_to("/groups/#{@group.permalink}/edit")
      end
    end
    
    context "missing parameters" do
      before { put :update, user_id: '123' }
    
      it "should NOT change user role to youth sponsor" do
        @user.reload.role.should_not == 'youth sponsor'
      end
    
      it "should set flash message" do
        flash[:alert].should =~ /error assigning youth sponsor/i
      end
      
      it "should redirect to groups edit" do
        response.should redirect_to("/groups/#{@group.permalink}/edit")
      end
    end
  end

  describe "#destroy" do
    before do 
      @user = Factory.create(:user, {email: 'member@test.com', role: 'youth sponsor', group: @group})
    end
    
    context "sucessfully" do
      before { delete :destroy, user_id: @user.id }
    
      it "should change user role to member" do
        @user.reload.role.should == 'member'
      end
    
      it "should set flash message" do
        flash[:notice].should =~ /sponsor removed/i
      end
    
      it "should send an email notification" do
        ActionMailer::Base.deliveries.last.to.should == [@user.email]
      end
      
      it "should redirect to groups edit" do
        response.should redirect_to("/groups/#{@group.permalink}/edit")
      end
    end
    
    context "missing parameters" do
      before { delete :destroy, user_id: '123' }
    
      it "should NOT change user role to member" do
        @user.reload.role.should_not == 'member'
      end
    
      it "should set flash message" do
        flash[:alert].should =~ /error removing youth sponsor/i
      end
      
      it "should redirect to groups edit" do
        response.should redirect_to("/groups/#{@group.permalink}/edit")
      end
    end
  end
end