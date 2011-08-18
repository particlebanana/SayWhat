require 'spec_helper'

describe Message do
  before do
    build_group_with_admin
    @project = Factory.build(:project)
    @group.projects << @project
    @project.save!
    @group.save!
  end
  
  describe "validations" do
    
    describe "of required fields" do 
      
      it "should allow a valid message to be created" do
        @message = Factory.build(:member_request)
        @message.should be_valid
        @admin.messages << @message
        @admin.save
        @admin.reload.messages.length.should == 1
      end
          
      it "should fail if message is not valid" do
        @message = Factory.build(:member_request, :subject => "")
        @message.should_not be_valid
      end
    end
    
    describe "of payloads" do
      before do
        @user = Factory.build(:user, :email => "billy.bob@gmail.com")
        set_status_and_role("pending", "pending")
        @group.users << @user
        @user.save
        @group.save
      end
      
      it "should allow a user id to be included as a payload" do
        @message = Factory.build(:member_request)
        @message.payload = @user.id
        @message.should be_valid
      end
    end
    
  end
  
end