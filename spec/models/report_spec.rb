require 'spec_helper'

describe Report do
  
  describe "validations" do
    
    describe "of required fields" do     

      it "should allow the creation of a report" do
        @report = Factory.build(:report)
        @report.should be_valid
      end
      
      it "should enforce required fields" do
        subject { Factory(:user) }
    
        should_not allow_value("").for(:number_of_youth_reached) 
        should_not allow_value("").for(:number_of_adults_reached) 
        should_not allow_value("").for(:percent_male) 
        should_not allow_value("").for(:percent_female)
        should_not allow_value("").for(:percent_african_american)
        should_not allow_value("").for(:percent_asian)
        should_not allow_value("").for(:percent_caucasian)
        should_not allow_value("").for(:percent_hispanic)
        should_not allow_value("").for(:percent_other)
        should_not allow_value("").for(:money_spent)
        should_not allow_value("").for(:prep_time)
      end
    end
        
  end
  
  describe "update project cache" do
    before(:each) do
      build_group_with_admin
      build_project
    end
    
    it "should have a flag of false for reported" do
      ProjectCache.first.reported.should == false
    end
    
    it "should flag reported on report save" do
      @report = Factory.build(:report)
      @project.report = @report
      @report.save
      ProjectCache.first.reported.should == true
    end
    
  end
  
end