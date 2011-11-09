require 'spec_helper'

describe Report do
  before do
    @group = FactoryGirl.create(:group)
    @project = FactoryGirl.create(:project, { group: @group })
    @report = FactoryGirl.create(:report, { group: @group, project: @project })
  end

  context "Factory" do
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
end
