require 'spec_helper'

describe UsersController do
    
  describe "setup a new group" do
    before do
      @group = Factory.create(:group)
      @user = Factory.build(:user_input)
      set_status_and_role("setup", "adult sponsor")
      @group.users << @user
    end
    
    it "should change a user's password" do
      put :create_password, {:id => @user.id.to_s, :password => "test123", :password_confirmation => "test1234"}
      response.should be_redirect
      
      sign_out @user
      # TO DO - Figure out how to test password was changed
    end
  
  end

end