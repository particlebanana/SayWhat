require 'spec_helper'

describe Report do
  
  it { should validate_presence_of(:group_id) }
  it { should validate_presence_of(:project_id) }
  
  it { should validate_presence_of(:number_of_youth_reached) }
  it { should validate_presence_of(:number_of_adults_reached) }
  it { should validate_presence_of(:percent_male) }
  it { should validate_presence_of(:percent_female) }
  it { should validate_presence_of(:percent_african_american) }
  it { should validate_presence_of(:percent_asian) }
  it { should validate_presence_of(:percent_caucasian) }
  it { should validate_presence_of(:percent_hispanic) }
  it { should validate_presence_of(:percent_other) }
  it { should validate_presence_of(:money_spent) }
  it { should validate_presence_of(:prep_time) }
  
  describe "factory" do
    it "should generate a report" do
      report = Factory.create(:report)
      report.valid? should be_true
    end
  end
  
  describe "create a report" do
    before do
      @report = Factory.create(:report)
    end 
    
    it "should update the group's counters" do
      counter = Counter.where(group_id: @report.group_id).first
      counter.youth_total.should == 10
      counter.adult_total.should == 10
    end
  end
end
