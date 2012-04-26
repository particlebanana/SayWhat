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

    it "should generate an object key" do
      # Once for the group and once for the project
      WebMock.should have_requested(:post, "http://localhost:7979/object").twice
    end

    it "should publish event to timeline" do
      WebMock.should have_requested(:post, %r|http://localhost:7979/event[?a-zA-Z0-9=&_]*|)
    end

    it "should regenerate an object key on update" do
      @project.save
      WebMock.should have_requested(:delete, "http://localhost:7979/object/project:#{@project.id}")
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