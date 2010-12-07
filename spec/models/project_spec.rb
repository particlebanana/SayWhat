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
      
      it "should fail if dates are blank" do
        @project = Factory.build(:project, :start_date => nil)
        @project.should_not be_valid
      end
      
      it "should fail if description is blank" do
        @project = Factory.build(:project, :description => nil)
        @project.should_not be_valid
      end     
      
    end
    
    describe "of system generated fields" do
      it "should automatically create name field based on display name input" do
        @project = Factory.build(:project)
        @project.valid?.should == true
        @project.name.should == "build+death+star"
      end
    end
        
  end
  
  describe "building project cache" do
    before(:each) do
      build_group_with_admin
    end
    
    it "should build a new project cache document on creation" do
      build_project
      ProjectCache.all.count.should == 1
    end
    
    it "should update the project cache on project update" do
      build_project
      @project.update_attributes(:display_name => "Test Cache Update")
      ProjectCache.all.count.should == 1
      ProjectCache.first.project_name.should == "Test Cache Update"
    end
    
  end
  
end