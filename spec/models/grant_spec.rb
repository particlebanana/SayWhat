require 'spec_helper'

describe Grant do
  
  describe "validations" do
    
    describe "of required fields" do     

      it "should allow the creation of a grant" do
        grant = Factory.build(:minigrant)
        grant.should be_valid
      end
      
      it "should enforce required fields" do
        subject { Factory(:minigrant) }
    
        should_not allow_value("").for(:group_name) 
        should_not allow_value("").for(:check_payable) 
        should_not allow_value("").for(:adult_name) 
        should_not allow_value("").for(:adult_phone) 
        should_not allow_value("").for(:adult_email) 
        should_not allow_value("").for(:adult_address)
        should_not allow_value("").for(:youth_name)
        should_not allow_value("").for(:youth_email)
        should_not allow_value("").for(:project_description)
        should_not allow_value("").for(:project_when)
        should_not allow_value("").for(:project_where)
        should_not allow_value("").for(:project_who)
        should_not allow_value("").for(:project_serve)
        should_not allow_value("").for(:project_goals)
        should_not allow_value("").for(:funds_need)
        should_not allow_value("").for(:community_partnerships)
        should_not allow_value("").for(:community_resources)
        
        should_not allow_value("abc@abc").for(:adult_email)
        should_not allow_value("abc@abc").for(:youth_email)
        
        should allow_value("abc@abc.com").for(:adult_email)
        should allow_value("abc@abc.com").for(:youth_email)
      end
    end
        
  end

end