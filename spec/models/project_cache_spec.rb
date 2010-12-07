require 'spec_helper'

describe ProjectCache do

  describe "validations" do
    before(:each) do
      build_group_with_admin
    end
    
    it "should set the cache group permalink" do
      build_project
      ProjectCache.first.group_permalink.should == @group.permalink
    end
    
    it "should set the cache project permalink" do
      build_project
      ProjectCache.first.project_permalink.should == @project.name
    end
                
    it "should fail if project_id is not unique" do
      build_project
      create_project_cache
      @project_cache.should_not be_valid
      @project_cache.errors.full_messages.first.should =~ /is already taken/i
    end
    
    describe "fail when missing" do
      before(:each) do
        build_project
        create_project_cache
      end
      
      it "nothing" do
        @project_cache.should_not be_valid
      end
      
      it "group_id" do
        @project_cache.group_id = nil
        @project_cache.should_not be_valid
      end
      
      it "project_id" do
        @project_cache.project_id = nil
        @project_cache.should_not be_valid
      end
      
    end
  
  end
      
end
