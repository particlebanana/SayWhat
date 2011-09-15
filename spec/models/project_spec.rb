require 'spec_helper'

describe Project do
  context "Factory" do
    before { @project = Factory.create(:project) }
    
    subject { @project }
    it { should belong_to(:group) }
    it { should have_many(:project_comments) }
    
    it { should validate_presence_of(:display_name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:focus) }
    it { should validate_presence_of(:goal) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:audience) }
    it { should validate_presence_of(:involves) }
  
    it { should validate_uniqueness_of(:name) }
  end
  
  describe "#escape_name" do
    before { @project = Factory.create(:project) }
    
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