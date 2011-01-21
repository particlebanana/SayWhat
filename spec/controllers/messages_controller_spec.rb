require 'spec_helper'

describe MessagesController do
  
  describe "before filters" do
    it "should not allow unauthenticated users to navigate" do
      get :index
      response.should be_redirect
    end
  end
  
  describe "#index" do
    before do
      @user = build_a_generic_user(1)
      sign_in @user
      seed_messages(5)
    end
    
    it "should assign the messages to an instance variable" do
      get :index
      assigns[:messages].count.should == 5
    end
    
  end
  
  describe "#create" do
    before(:each) do
      build_group_with_admin
      @user = build_a_generic_user(10)
      @group.users << @user
      @group.save!
      sign_in @admin
    end
    
    it "should send a message to all members in the group" do
      message = build_message_params
      post :create, message
      response.should be_redirect
      @user.reload.messages.count.should == 1
      @user.reload.messages.first.message_subject.should == "Test Subject"
    end
    
  end
  
  describe "#show" do
    before(:each) do
      @user = build_a_generic_user(1)
      sign_in @user
      seed_messages(5)
    end
    
    it "should display the message" do
      get :show, {:id => @user.messages.last.id.to_s}
      assigns[:message].message_subject.should == "Generic Message"
      assigns[:message].message_content.should == "This is a generic message"
    end
  end
  
    
  describe "#destroy" do
    before(:each) do
      @user = build_a_generic_user(1)
      sign_in @user
      seed_messages(1)
    end
    
    it "should allow the user to delete a message" do
      delete :destroy, :id => @user.messages.last.id.to_s
      @user.reload.messages.count.should == 0
    end
    
  end
  
end