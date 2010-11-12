require 'spec_helper'

describe UsersController do
    
  describe "setup a new group" do
    
    it "should change a sponsor's password" do
      @group = Factory.create(:group)
      @user = Factory.build(:user_input)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
      
      sign_in @user
      put :create_sponsor, {:id => @user.id.to_s, :user => {:password => "test123", :password_confirmation => "test123"}}
      response.should be_redirect
    end
    
    it "should reset the sponsor's token" do
      @group = Factory.create(:group)
      @user = Factory.build(:user_input)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
      
      sign_in @user
      token = @user.authentication_token
      put :create_sponsor, {:id => @user.id.to_s, :user => {:password => "test123", :password_confirmation => "test123"}}
      response.should be_redirect
      @user = User.find(@user.id.to_s)
      @user.authentication_token.should_not == token
    end
      
  end

end