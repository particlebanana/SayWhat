require 'spec_helper'

describe YouthSponsorsController do
  before do
    @group = FactoryGirl.create(:group)
  end
  
  context "adult sponsor" do
    before do
      user = FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      sign_in user
    end
  
    describe "#index" do
      before do 
        FactoryGirl.create(:user, {email: 'member@test.com', group: @group})
        get :index
      end
    
      it "should return all active group users with role of member" do
        (assigns[:members].all.is_a? Array).should be_true
        assigns[:members].all.count.should == 1 # only return member and not adult sponsor
      end
    
      it "should render index template" do
        response.should render_template('youth_sponsors/index')
      end
    end
  
    describe "#update" do
      before do 
        @user = FactoryGirl.create(:user, {email: 'member@test.com', role: 'member', group: @group})
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
        @user = FactoryGirl.create(:user, {email: 'member@test.com', role: 'youth sponsor', group: @group})
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
  
  # Check permissions on actions - Should not allow group member to edit sponsor.
  context "member" do
    before do
      user = FactoryGirl.create(:user, {role: "member", group: @group})
      sign_in user
    end
    
    describe "#index" do
      before { get :index }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    describe "#update" do
      before { put :update }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    describe "#destroy" do
      before { delete :destroy }
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end
end