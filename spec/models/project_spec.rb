require 'spec_helper'

describe Project do
  before do
    @group = FactoryGirl.create(:group)
    @project = FactoryGirl.create(:project, { group: @group } )
  end

  context "Factory" do
    
    subject { @project }
    it { should belong_to(:group) }
    
    it { should validate_presence_of(:display_name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:focus) }
    it { should validate_presence_of(:audience) }
    it { should validate_presence_of(:description) }
  
    it { should validate_uniqueness_of(:name) }

    it "should queue a NewProjectJob" do
      NewProjectJob.should have_queued(@project.id)
    end

    it "should queue a UpdateProjectJob on update" do
      @project.save
      UpdateProjectJob.should have_queued(@project.id)
    end
  end
  
  describe "#escape_name" do
    it "should generate a name field" do
      @project.name.should_not be_nil
    end
    
    it "should escape special characters" do
      @project.display_name = "It's A Trap!?!?!"
      @project.valid?.should == true
      @project.name.should == "its-a-trap"    
    end
  end 
end