require 'spec_helper'

describe Report do
  context "Factory" do
    before { @report = FactoryGirl.create(:report) }
  
    subject { @report }
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
  end
  
  describe "#update_counter" do
    before { @report = FactoryGirl.create(:report) } 
    
    it "should update the group's counters" do
      counter = Counter.where(group_id: @report.group_id).first
      counter.youth_total.should == 10
      counter.adult_total.should == 10
    end
  end
end
