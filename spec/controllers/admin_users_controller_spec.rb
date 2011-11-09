require 'spec_helper'
include CarrierWave::Test::Matchers

describe AdminUsersController do

  describe "#index" do
    before do
      FactoryGirl.create(:user)
      admin = FactoryGirl.create(:user, {email: "admin@test.com", role: "admin"})
      sign_in admin
    end

    it "should list all users" do
      get :index
      assigns[:users].count.should == 2 # Admin and user
    end
  end
  
  describe "#edit" do
    before do
      @user = FactoryGirl.create(:user)
      admin = FactoryGirl.create(:user, {email: "admin@test.com", role: "admin"})
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
      @user = FactoryGirl.create(:user)
      admin = FactoryGirl.create(:user, {email: "admin@test.com", role: "admin"})
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
      @user = FactoryGirl.create(:user)
      @sponsor = FactoryGirl.create(:user, {email: "sponsor@test.com", role: "adult sponsor"})
      admin = FactoryGirl.create(:user, {email: "admin@test.com", role: "admin"})
      sign_in admin
    end
    
    context "member" do
      before { delete :destroy, { id: @user.id } }
      
      it "should delete" do
        User.where(id: @user.id).first.should == nil
      end
    end
    
    context "adult sponsor" do
      before { delete :destroy, { id: @user.id } }
      
      it "should not delete" do
        User.where(id: @sponsor.id).first.should_not == nil
      end
    end
  end

end