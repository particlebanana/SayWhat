require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminUsersController do

  describe "#index" do
    before do
      Factory.create(:user)
      admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
      sign_in admin
    end

    it "should list all users" do
      get :index
      assigns[:users].count.should == 2 # Admin and user
    end
  end
  
  describe "#edit" do
    before do
      @user = Factory.create(:user)
      admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
      sign_in admin
    end

    it "should find a user by id" do
      get :edit, { id: @user.id }
      assigns[:user].first_name.should == @user.first_name
      assigns[:user].last_name.should == @user.last_name
      assigns[:user].email.should == @user.email
    end
  end

  describe "#update" do
    before do
      @user = Factory.create(:user)
      admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
      sign_in admin
    end

    it "should update a user resource" do
      put :update, { id: @user.id, user: {first_name: 'update_test'} }
      response.should redirect_to("/admin/users/#{@user.id}")
      @user.reload.first_name.should == 'update_test'
    end
  end
  
  describe "#destroy" do
    before(:each) do      
      @user = Factory.create(:user)
      @sponsor = Factory.create(:user, {email: "sponsor@test.com", role: "adult sponsor"})
      admin = Factory.create(:user, {email: "admin@test.com", role: "admin"})
      sign_in admin
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
=begin 
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
=end
end