require 'spec_helper'

describe Project do
  
  describe "validations" do
    describe "of required fields" do 
      it "should fail if display name is blank" do
        @project = Factory.build(:project, :display_name => nil)
        @project.should_not be_valid
      end
      
      it "should fail if location is blank" do
        @project = Factory.build(:project, :location => nil)
        @project.should_not be_valid
      end
      
      it "should fail if start date is blank" do
        @project = Factory.build(:project, :start_date => nil)
        @project.should_not be_valid
      end
      
      it "should fail if end date is blank" do
        @project = Factory.build(:project, :end_date => nil)
        @project.should_not be_valid
      end
      
      it "should fail if focus is blank" do
        @project = Factory.build(:project, :focus => nil)
        @project.should_not be_valid
      end
      
      it "should fail if goal is blank" do
        @project = Factory.build(:project, :goal => nil)
        @project.should_not be_valid
      end
      
      it "should fail if description is blank" do
        @project = Factory.build(:project, :description => nil)
        @project.should_not be_valid
      end 
      
      it "should fail if audience is blank" do
        @project = Factory.build(:project, :audience => nil)
        @project.should_not be_valid
      end
      
      it "should fail if involves is blank" do
        @project = Factory.build(:project, :involves => nil)
        @project.should_not be_valid
      end
      
      it "should validate uniqueness of name" do
        project = Factory.build(:project)
        project.save
        project2 = Factory.build(:project)
        project2.should_not be_valid
        project2.display_name = 'project 2'
        project2.should be_valid
      end
      
    end
    
    describe "of system generated fields" do
      it "should automatically create name field based on display name input" do
        @project = Factory.build(:project)
        @project.valid?.should == true
        @project.name.should == "build-death-star"
      end
      
      it "should escape special characters from the input" do
        @project = Factory.build(:project, :display_name => "This Isn't A Valid Name!?!?!")
        @project.valid?.should == true
        @project.name.should == "this-isnt-a-valid-name"
      end
    end  
  end
  
end