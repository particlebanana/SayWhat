require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminController do

  describe "#show_requests" do
    before do
      @group = Factory.create(:pending_group)
      @user = Factory.build(:user)
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
      @user = Factory.build(:user)
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
  
  describe "#show_groups" do
    before do
      @grant = Factory.create(:group)
      login_admin
    end
    
    it "should list all groups" do
      get :show_groups
      assigns[:groups].count.should == 1
    end
  end
  
  describe "#view_group" do
    before do
      build_group_with_admin
      login_admin
    end
    
    it "should find the group by id" do
      get :view_group, :id => @group.id.to_s
      assigns[:group].should_not be_nil
    end
  end
  
  describe "#update" do
    before do
      build_group_with_admin
      login_admin
    end
    
    context "successfully" do
      before(:each) { do_update_group() }
      
      subject{ @group.reload }
      its(:display_name) { should == "Rebel Alliance" }
      its(:name) { should == "rebel alliance" }
    end
  end
  
  describe "#group_approval_email" do
    before do
      @group = Factory.create(:pending_group, :status => "setup")
      @user = Factory.build(:user)
      set_status_and_role("setup", "admin")
      @group.users << @user
      @user.save!
      login_admin
    end
    
    context "send approval email" do
      before(:each) { do_group_approval_email }
    
      subject{ ActionMailer::Base.deliveries.last }
      its(:subject) { should == "Your group has been approved on SayWhat!" }
      its(:to) { should == ["han.solo@gmail.com"] }
    end
  end
  
  describe "#choose_a_sponsor" do
    before do
      build_decaying_group
      login_admin
    end
    
    it "should pull a list of group members" do
      get :choose_sponsor, { id: @group.id.to_s }
      assigns[:members].count.should == 1
    end
  end
  
  describe "#reassign_sponsor" do
    before(:each) do
      @user = build_decaying_group
      login_admin
    end
    
    context "admin to group member" do
      before(:each) { do_reassign_sponsor }
      
      subject { @captain_zissou.reload }
      its(:role) { should == "member" }
    end
    
    context "member to group sponsor" do
      before(:each) { do_reassign_sponsor }
            
      subject { @user.reload }
      its(:role) { should == "adult sponsor" }
    end
  end
 
  describe "#remove_avatar" do
    before(:each) do
      setup_user_avatar
      login_admin
    end
        
    context "admin panel" do      
      it "should completely remove an inappropriate avatar" do
        do_remove_avatar
        @user.reload.avatar.should == nil
      end
    end
  end

  describe "#destroy_user" do
    before(:each) do
      @user = build_a_generic_user(1)
      @user.save
      @sponsor = build_a_generic_admin(1)
      @sponsor.save
      login_admin
    end
    
    context "member" do
      before(:each) { do_destroy_user(id: @user.id) }
      
      it "should delete" do
        User.where(id: @user.id).first.should == nil
      end
    end
    
    context "adult sponsor" do
      before(:each) { do_destroy_user(id: @sponsor.id) }
      
      it "should not delete" do
        User.where(id: @sponsor.id).first.should_not == nil
      end
    end
  end

end