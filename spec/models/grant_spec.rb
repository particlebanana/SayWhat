require 'spec_helper'

describe Grant do
  context "Factory" do
    before { @grant = Factory.create(:grant) }
    
    subject { @grant }    
    it { should validate_presence_of(:group_name) }
    it { should validate_presence_of(:check_payable) }
    it { should validate_presence_of(:adult_name) }
    it { should validate_presence_of(:adult_phone) }
    it { should validate_presence_of(:adult_email) }
    it { should validate_presence_of(:adult_address) }
    it { should validate_presence_of(:youth_name) }
    it { should validate_presence_of(:youth_email) }
    it { should validate_presence_of(:project_description) }
    it { should validate_presence_of(:project_when) }
    it { should validate_presence_of(:project_where) }
    it { should validate_presence_of(:project_who) }
    it { should validate_presence_of(:project_serve) }
    it { should validate_presence_of(:project_goals) }
    it { should validate_presence_of(:funds_need) }
    it { should validate_presence_of(:community_partnerships) }
    it { should validate_presence_of(:community_resources) }
    
    it { should_not allow_value("abc@abc").for(:adult_email) }
    it { should_not allow_value("abc@abc").for(:youth_email) }
    it { should allow_value("abc@abc.com").for(:adult_email) }
    it { should allow_value("abc@abc.com").for(:youth_email) }
  end
  
  describe "#deny" do
    before do
      @grant = Factory.create(:grant)
      reasons = YAML.load(File.read(Rails.root.to_s + "/config/denied_reasons.yml"))['reasons']['grants']
      @reason = reasons.first
    end
    
    context "success" do
      before { @response = @grant.deny(@reason) }
      
      subject { @response }
      it { should be_true }
      
      it "should destroy self" do
        Grant.where(id: @grant.id).count.should == 0
      end
    
      it "should send an email" do
        ActionMailer::Base.deliveries.last.subject.should =~ /grant has been denied/i
      end
    end
    
    context "invalid" do
      before { @response = @grant.deny('') }
      
      subject { @response }
      it { should be_false }
    end
  end
  
  describe "#approve" do
    before do
      @grant = Factory.create(:grant)
      @response = @grant.approve
    end
    
    subject { @response }
    it { should be_true }
      
    it "should set grant status to true" do
      @grant.reload.status.should == true
    end
    
    it "should send an email" do
      ActionMailer::Base.deliveries.last.subject.should =~ /grant has been approved/i
    end
    
  end
end