require 'spec_helper'

describe Group do
  
  describe "validations" do
    subject { Factory(:group) }

    it { should validate_presence_of :name }
    it { should validate_presence_of :city }
    it { should validate_presence_of :organization }
    it { should validate_uniqueness_of :name }
  end
  
  describe "create groups" do
    
    it "should create a pending group" do
      @group = Factory(:pending_group)
      @group.valid?.should be_true
    end
    
    it "should create a full group" do
      @group = Factory(:group)
      @group.valid?.should be_true
    end
  
  end

end
