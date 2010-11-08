require 'spec_helper'

describe Group do
  
  describe "validations" do
    subject { Factory(:group) }

    #it { should validate_presence_of :name }
    it { should validate_presence_of :city }
    it { should validate_presence_of :organization }
    it { should validate_uniqueness_of :name }
    it { should validate_uniqueness_of :permalink }
    
    it { should_not allow_value("bla").for(:permalink) }
    it { should_not allow_value("blahblahblahblahblahblah").for(:permalink) }
    
  end
  
  describe "before validation filters" do
    it "should escape permalink" do
      @group = Factory(:pending_group)
      @group.permalink = "This Is A Test"
      @group.valid?.should be_true
      @group.permalink.should == "this+is+a+test"
    end
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
    
    it "should fail if name already exists" do
      @base_group = Factory(:group)
      @test_group = Factory.build(:pending_group, :name => "Jedi Knights")
      @test_group.valid?.should_not be_true
    end
    
    it "should fail if permalink already exists" do
      @base_group = Factory(:group)
      @test_group = Factory.build(:pending_group)
      @test_group.permalink = "jedi-knights"
      @test_group.valid?.should_not be_true
    end
  
  end

end
