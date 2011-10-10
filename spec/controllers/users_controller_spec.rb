require 'spec_helper'

describe UsersController do
  
  describe "#edit" do
    before do
      user = Factory.create(:user)
      sign_in user
      get :edit
    end
    
    it "should assign @user" do
      (assigns[:user].is_a? User).should be_true
    end
    
    it "should render edit template" do
      response.should render_template('users/edit')
    end
  end
  
  describe "#update" do
    before do
      @user = Factory.create(:user)
      sign_in @user
      put :update, { id: @user.id, user: { first_name: "Jabba", last_name: "The Hut" } }
    end
    
    it "should update the User object" do
      @user.reload.name.should == "Jabba The Hut"
    end
    
    it "should redirect to edit action" do
      response.should redirect_to('/settings/profile')
    end
    
    it "should set a notice message" do
      flash[:notice].should =~ /has been updated/i
    end
  end
end