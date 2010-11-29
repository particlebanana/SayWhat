require 'spec_helper'

describe Project do
  
  describe "validations" do
    
    describe "of required fields" do     
      it "should fail if name is blank" do
        @project = Factory.build(:project, :name => nil)
        @project.should_not be_valid
      end
      
      it "should fail if location is blank" do
        @project = Factory.build(:project, :location => nil)
        @project.should_not be_valid
      end
      
      it "should fail if dates are blank" do
        @project = Factory.build(:project, :start_date => nil)
        @project.should_not be_valid
      end
      
      it "should fail if description is blank" do
        @project = Factory.build(:project, :description => nil)
        @project.should_not be_valid
      end     
    end
    
  end
  
end