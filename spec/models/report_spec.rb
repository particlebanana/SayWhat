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
    
        should_not allow_value("").for(:project_id) 
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

end
