require 'spec_helper'

describe Group do
  before do
    @group = FactoryGirl.create(:group)
  end
  
  context "Factory" do
    subject { @group }
    it { should have_many(:users) }
    it { should have_many(:projects) }
    it { should have_many(:memberships) }
    
    it { should validate_presence_of(:display_name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:organization) }
    it { should validate_presence_of(:permalink) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:esc_region) }
    it { should validate_presence_of(:dshs_region) }
    it { should validate_presence_of(:area) }
  
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:permalink) }
  
    it { should validate_length_of(:permalink).within(4..20) }
    
    it "should downcase name field" do
      @group.name.should == @group.display_name.downcase
    end
  end

  describe "#update" do
    before { @group.update_attributes({:status => "active"}) }

    it "should queue a UpdateGroupJob" do
      UpdateGroupJob.should have_queued(@group.id)
    end
  end

  describe "#adult_sponsor" do
    before do
      FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      @user = @group.adult_sponsor
    end
    
    it "should return a user object" do
      @user.is_a?(User).should be_true
    end
  end
    
  describe "#initialize_pending" do
    before do
      @user = FactoryGirl.create(:user)
      @group.permalink = "It's A Trap!?!?!"
      @response = @group.initialize_pending(@user)
    end
    
    describe "#setup_group" do
      subject { @group.reload }
      its([:status]) { should == 'pending' }
      its([:permalink]) { should == 'its-a-trap'}
    end
    
    it "should queue a NewGroupJob" do
      NewGroupJob.should have_queued(@group.id, @user.id)
    end
    
    it "should return true" do 
      @response.should == true
    end
  end
  
  describe "#approve" do
    before do
      @user = FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      @response = @group.approve("http://test.com")
    end

    subject { @response }
    it { should be_true }

    it "should set the group status to active" do
      @group.reload.status.should == 'active'
    end

    it "should queue a ManageGroupRequestJob" do
      ManageGroupRequestJob.should have_queued(@user.id, @group.id, "http://test.com", 'approve')
    end
  end

  describe "#deny" do
    before do
      @user = FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['groups']
      @reason = reasons.first
      @id = @group.id
    end
    
    context "success" do
      before { @response = @group.deny(@reason) }
      
      subject { @response }
      it { should be_true }
      
      it "should destroy self" do
        Group.where(id: @group.id).count.should == 0
      end
    
      it "should queue a ManageGroupRequestJob" do
        ManageGroupRequestJob.should have_queued(@user.id, @id, @reason["email_text"], 'deny')
      end
    end
    
    context "invalid" do
      before { @response = @group.deny('') }
      
      subject { @response }
      it { should be_false }
    end
  end
  
  describe "#reassign_sponsor" do
    before do
      @sponsor = FactoryGirl.create(:user, {role: "adult sponsor", group: @group})
      @member = FactoryGirl.create(:user, {email: "member@test.com", group: @group})
      @group.reassign_sponsor(@member.id)
    end
    
    context "@sponsor" do
      subject{ @sponsor.reload }
      its(:role) { should == "member" }
    end
    
    context "@member" do  
      subject{ @member.reload }
      its(:role) { should == "adult sponsor" }
    end
  end
end