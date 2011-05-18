require 'spec_helper'

describe User do 
  
  describe "validation" do 
    
    describe "of mass assignment fields" do
    
      it "fails if name is not present" do
        @user = Factory.build(:user)
        set_status_and_role("pending", "pending")
        @user.should be_valid
        
        @user.first_name = nil
        @user.should_not be_valid
        
        @user.errors.count.should == 1
        @user.errors.full_messages.first.should =~ /First name can't be blank/i
      end
      
      it "fails if email is not present" do
        @user = Factory.build(:user)
        set_status_and_role("pending", "pending")
        @user.should be_valid
        
        @user.email = nil
        @user.should_not be_valid
      end
      
      it "fails if email is not unique" do
        @user = Factory.build(:user)
        set_status_and_role("pending", "pending")
        @user.save
        
        user = Factory.build(:user_input)
        user.should_not be_valid
        
        user.errors.full_messages.first.should =~ /is already taken/i
      end
      
      it "ensures email address is in the correct format" do
        subject { Factory(:user) }
        
        should_not allow_value("blah").for(:email)
        should_not allow_value("b lah").for(:email)
        should allow_value("a@b.com").for(:email)
        should allow_value("asdf@asdf.com").for(:email)
      end
            
    end
    
    describe "of roles and status" do
      
      it "requires presence of role" do
        user = Factory.build(:user_input)
        user.status = "pending"
        user.should_not be_valid
        
        user.role = "pending"
        user.should be_valid 
      end
      
      it "requires presence of status" do
        user = Factory.build(:user_input)
        user.role = "pending"
        user.should_not be_valid
        
        user.status = "pending"
        user.should be_valid
      end
      
    end
    
    describe "of system generated fields" do
      
      it "downcases email addresss" do
        @user = Factory.build(:user_input)
        set_status_and_role("pending", "pending")
        
        @user.email = "This.Is.A.Test@gmail.com"
        @user.should be_valid
        @user.email.should == "this.is.a.test@gmail.com"
      end
      
      it "generates a temporary password if no password exists" do
        user = Factory.build(:user_input)
        user.should_not be_valid
        user.encrypted_password.should_not == ""
      end
      
      it "generate an authentication token" do
        @user = Factory.build(:user_input)
        set_status_and_role("pending", "pending")
        @user.should be_valid
        @user.save
        @user.authentication_token.should_not == nil
      end
      
      it "combines first name and last name" do
        @user = Factory.build(:user_input)
        @user.name.should == "Han Solo"
      end
      
    end
        
  end 
  
  describe ".change_role_level" do
    before(:each) { @user = build_decaying_group }
    
    context "promote user to adult sponsor" do
      before(:each) { @user.change_role_level('adult sponsor') }
      
      subject{ @user.reload }
      its(:role) { should == 'adult sponsor' }
    end
    
    context "demote an admin to member" do
      before(:each) { @captain_zissou.change_role_level('member') }
      
      subject{ @captain_zissou.reload }
      its(:role) { should == 'member' }
    end
    
  end
 
end