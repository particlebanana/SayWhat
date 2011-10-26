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
    context "user settings" do
      before do
        @user = Factory.create(:user)
        sign_in @user
        put :update, { id: @user.id, user: { first_name: "Jabba", last_name: "The Hut" } }
      end
    
      it "should update the User object" do
        @user.reload.name.should == "Jabba The Hut"
      end

      it "should redirect to edit action" do
        response.should redirect_to('/settings')
      end
    
      it "should set a notice message" do
        flash[:notice].should =~ /has been updated/i
      end

      it "should regenerate an object key on update" do
        res = JSON.parse($feed.retrieve("user:#{@user.id}").body)
        res['photo'].should == @user.profile_photo_url(:thumb)
      end
    end

    context "join group" do
      before do
        @user = Factory.create(:user)
        @group = Factory.create(:group)
        sign_in @user
        put :update, { id: @user.id, group_id: @group.id, user: {} }
      end
    
      it "should add a group_id param to the user" do
        @user.reload.group.should == @group
      end

      it "should redirect to the group page" do
        response.should redirect_to("/groups/#{@group.permalink}")
      end
    end

    context "try and change groups" do
      before do
        @user = Factory.create(:user)
        @group = Factory.create(:group)
        @user.group = @group
        @user.save
        sign_in @user
        put :update, { id: @user.id, group_id: (@group.id + 1), user: {} }
      end

      it "should add a group_id param to the user" do
        @user.reload.group.id.should == @group.id
      end

      it "should redirect to the settings page" do
        response.should redirect_to("/settings")
      end
    end
  end
end