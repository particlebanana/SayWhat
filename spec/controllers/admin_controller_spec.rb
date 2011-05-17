require 'spec_helper'

describe AdminController do

  describe "#show_requests" do
    before do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user_input)
      set_status_and_role("pending", "pending")
      @group.users << @user
      @user.save!
      login_admin
    end
    
    it "should list all the pending group requests by date" do
      get :show_requests
      assigns[:groups].count.should == 1
    end
  end
  
  describe "#view_request" do
    before do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user_input)
      set_status_and_role("pending", "pending")
      @group.users << @user
      @user.save!
      login_admin
    end
    
    it "should find the pending group by id" do
      get :view_request, :id => @group.id.to_s
      assigns[:group].should_not be_nil
    end
  end
  
  describe "#show_grants" do
    before do
      @grant = Factory.create(:minigrant, :status => true)
      login_admin
    end
    
    it "should list all the active grants" do
      get :show_grants
      assigns[:grants].count.should == 1
    end
  end
  
  describe "#show_pending_grants" do
    before do
      @grant = Factory.create(:minigrant, :status => false)
      login_admin
    end
    
    it "should list all the pending grants" do
      get :show_pending_grants
      assigns[:grants].count.should == 1
    end
  end
  
  describe "#approve_grant" do
    before(:each) do
      @grant = Factory.create(:minigrant, :status => false)
      login_admin
    end
    
    context "successfully" do
      before(:each) { do_approve_grant(id: "#{@grant.id}") }
      
      subject { response }
      it { should redirect_to('/admin/grants') }
            
      it "should send the adult contact an email" do
        ActionMailer::Base.deliveries.last.subject.should == "SayWhat! Mini-Grant Has Been Approved"
      end
            
      subject{ @grant.reload }
      its(:status) { should == true }
    end
  end
  
  describe "#deny_grant" do
    before(:each) do
      @grant = Factory.create(:minigrant, :status => false)
      login_admin
    end
    
    context "successfully" do
      before(:each) { do_deny_grant(id: "#{@grant.id.to_s}", reason: "curriculum")}
      
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
      before(:each) { do_deny_grant(id: "#{@grant.id.to_s}", reason: "") }
      
      subject { response }
      it { should redirect_to("/admin/grants/#{@grant.id}") }
    end
  end
end