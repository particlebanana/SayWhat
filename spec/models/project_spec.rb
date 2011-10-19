require 'spec_helper'

describe Project do
  before do
    @group = Factory.create(:group)
    @project = Factory.create(:project, { group: @group } )
  end

  context "Factory" do
    
    subject { @project }
    it { should belong_to(:group) }
    
    it { should validate_presence_of(:display_name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:focus) }
    it { should validate_presence_of(:audience) }
    it { should validate_presence_of(:description) }
  
    it { should validate_uniqueness_of(:name) }

    it "should generate an object key" do
      $feed.retrieve("project_#{@project.id}").code.should == 200
    end

    it "should publish to the group timeline" do
      timeline = $feed.timeline("group:#{@project.group_id}")
      timeline["feed"].first["key"].should include("project:#{@project.id}:create")
    end

    it "should regenerate an object key on update" do
      @project.name = 'update test'
      @project.save
      res = JSON.parse($feed.retrieve("project:#{@project.id}").body)
      res['photo'].should == @project.profile_photo_url(:thumb)
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