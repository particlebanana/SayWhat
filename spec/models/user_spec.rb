require 'spec_helper'

describe User do
  before { @user = Factory.create(:user) }
  
  subject { @user }  
  it { should belong_to(:group) }
  it { should have_many(:comments) }
  it { should have_many(:messages) }
  
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:role) }
  it { should validate_presence_of(:status) }
  
  it { should validate_uniqueness_of(:email) }
  #it { should validate_format_of(:email) }
  
  describe "factory" do
    before { User.first.destroy }
    
    it "should generate a user" do
      user = Factory.create(:user)
      user.valid? should be_true
    end
    
    it "should generate an authrntication token" do
      user = Factory.create(:user)
      user.authentication_token.should_not == nil
    end
  end 
  
  describe "#name" do
    before { User.first.destroy }
    
    it "should combine first and last name" do
      user = Factory.create(:user)
      user.name.should == "#{user.first_name} #{user.last_name}"
    end
  end
  
  describe "#change_role_level" do
    before { User.first.destroy }
    
    it "should change a users role" do
      user = Factory.create(:user)
      user.change_role_level('adult sponsor')
      user.reload.role.should == "adult sponsor"
    end
  end
  
  describe "role" do
    before(:each) { User.all.each {|u| u.destroy} }
    
    context "admin" do
      subject { Factory.create(:user, {role: "admin"}) }
      its(:admin?) { should be_true }
    end
    
    context "adult sponsor" do
      subject { Factory.create(:user, {role: "adult sponsor"}) }
      its(:adult_sponsor?) { should be_true }
      its(:sponsor?) { should be_true }
    end
    
    context "youth sponsor" do
      subject { Factory.create(:user, {role: "youth sponsor"}) }
      its(:youth_sponsor?) { should be_true }
      its(:sponsor?) { should be_true }
    end
  end

end