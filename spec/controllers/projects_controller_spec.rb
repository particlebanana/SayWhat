require 'spec_helper'

describe ProjectsController do
  before do
    @group = Factory.create(:group)
    @user = Factory.build(:user)
    set_status_and_role("active", "member")
    @group.users << @user
    @user.save
  end
  
  describe "create" do
        
    it "should add a project to a group" do 
      sign_in @user
      
      project = {
        :permalink => @group.permalink,
        :project => {
          :display_name =>  "Build Death Star",
          :location => "Outer Space",
          :start_date => "11-11-2011",
          :end_date => "11-12-2011",
          :description => "A Top Secret project"
        }
      }
  
      post :create, project
      response.should be_redirect
      group = Group.find(@group.id)
      group.projects.count.should == 1
    end
    
  end

end