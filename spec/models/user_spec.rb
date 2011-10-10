require 'spec_helper'

describe User do
  context "Factory" do
    before { @user = Factory.create(:user) }
  
    subject { @user }  
    it { should belong_to(:group) }
    it { should have_many(:memberships) }
  
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
  
    it { should validate_uniqueness_of(:email) }
  
    it { should_not allow_value("abc@abc").for(:email) }
    it { should allow_value("abc@abc.com").for(:email) }
          
    it "should generate an authentication token" do
      @user.authentication_token.should_not == nil
    end
    
    it "should generate an object key" do
      $feed.retrieve("user:#{@user.id}").code.should == 200
    end

    it "should subscribe user to the global timeline" do
      $feed.connected?("global_feed", "user:#{@user.id}").should == 'b'
    end
  end 

  describe "#set_defaults" do
    before do
      @user = Factory.build(:user, { email: "default@test.com" } )
      @user.valid?
    end

    subject { @user }

    its([:status]) { should == 'active' }
    its([:role]) { should == 'member' }
  end

  describe "#name" do
    before { @user = Factory.create(:user) }
    
    it "should combine first and last name" do
      @user.name.should == "#{@user.first_name} #{@user.last_name}"
    end
  end
  
  describe "#change_role_level" do
    before { @user = Factory.create(:user) }
    
    it "should change a users role" do
      @user.change_role_level('adult sponsor')
      @user.reload.role.should == "adult sponsor"
    end
  end
  
  describe "#activate" do
    before do 
      @user = Factory.create(:user, {role: "pending", status: "pending"})
      @user.activate
    end
    
    subject { @user.reload }
    its([:role]) { should == "member" }
    its([:status]) { should == "active" }
  end
  
  describe "#join_group" do
    before do
      @user = Factory.create(:user)
      @group = Factory.create(:group)
      @response = @user.join_group(@group.id)
    end
    
    subject { @user.reload }
    its([:group_id]) { should == @group.id }
    
    it "should return true" do
      @response.should == true
    end
  end
  
  describe "role" do    
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