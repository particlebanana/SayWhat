require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminController do
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