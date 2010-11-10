require 'spec_helper'

describe UsersController do
    
  describe "setup a new group" do
    
    it "should change a sponsor's username" do
      @group = Factory.create(:group)
      @user = Factory.build(:user_input)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
      
      sign_in @user
      put :create_sponsor, {:id => @user.id.to_s, :user => {:username => "test123", :password => "test123", :password_confirmation => "test123"}}
      response.should be_redirect
      @group.users.first.username.should == "test123"
    end
    
    # TO DO Test that a user's new password was accepted
  
  end

end