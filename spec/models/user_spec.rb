require 'spec_helper'

describe "A User" do 
  describe "validations" do 
    subject { Factory(:user) } 
    
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:status) }
  
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:username) }
  
    it { should_not allow_value("blah").for(:email) }
    it { should_not allow_value("b lah").for(:email) }
    it { should allow_value("a@b.com").for(:email) }
    it { should allow_value("asdf@asdf.com").for(:email) }
  end 
  
  
  describe "should manage tokens" do
    
    it "should create a token only if status is set to setup" do
      @user = Factory.create(:setup_user)
      @user.authentication_token.should_not == nil
    end
    
    it "should destroy a token on save if the status is anything other than setup" do
      @user = Factory.create(:setup_user)
      @user.status = "active"
      @user.save
      @user.authentication_token.should == nil
    end
    
  end
    
end 