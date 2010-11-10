require 'spec_helper'

describe Group do
  
  describe "validations" do
    
    describe "of base setup fields" do
      
      it "should create a name field based on display name" do
        @group = Factory.build(:pending_group)
        @group.valid?
        @group.name.blank?.should_not be_true
      end
      
      it "should fail if name is not unique" do
        Factory.create(:pending_group)
        
        @group = Factory.build(:pending_group)
        @group.should_not be_valid
        @group.errors.full_messages.first.should =~ /is already taken/i
      end
      
      it "should fail if display name is blank" do
        @group = Factory.build(:pending_group)
        @group.display_name = nil
        @group.should_not be_valid
      end
      
      it "should fail if city is blank" do
        @group = Factory.build(:pending_group)
        @group.city = nil
        @group.should_not be_valid
      end
      
      it "should fail if organization is blank" do
        @group = Factory.build(:pending_group)
        @group.organization = nil
        @group.should_not be_valid
      end
            
    end
    
  end
  
  describe "permalink" do
    
    it "should fail if less than 4 characters" do
      @group = Factory.build(:pending_group)
      @group.permalink = "bla"
      @group.should_not be_valid
    end
    
    it "should fail if more than 20 characters" do
      @group = Factory.build(:pending_group)
      @group.permalink = "blahblahblahblahblahblah"
      @group.should_not be_valid
    end
    
    it "should fail if not unique" do
      group = Factory.build(:pending_group)
      group.permalink = "blah"
      group.save
      
      @group = Factory.build(:pending_group, :display_name => "Test")
      @group.permalink = "blah"
      @group.should_not be_valid
    end
    
    it "should escape permalink" do 
      @group = Factory.build(:pending_group)
      @group.permalink = "This Is A Test"
      @group.should be_valid
      @group.permalink.should == "this+is+a+test"
    end
    
  end

end
