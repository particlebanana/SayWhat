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
end