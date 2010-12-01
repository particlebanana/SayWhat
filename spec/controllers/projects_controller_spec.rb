require 'spec_helper'

describe ProjectsController do
  before do
    @group = Factory.create(:group)
    @user = Factory.build(:user)
    set_status_and_role("active", "adult sponsor")
    @group.users << @user
    @user.save
    @user2 = Factory.build(:user, :email => "luke.skywalker@gmail.com")
    @user2.status = "active"
    @user2.role = "member"
    @group.users << @user2
    @user2.save
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
      @group.reload.projects.count.should == 1
    end
    
  end
  
  describe "edit" do
    before do
      @project = Factory.build(:project)
      @group.projects << @project
      @project.save
    end
    
    it "should update a project with new values" do
      sign_in @user
      put :update, {:permalink => @group.permalink, :name => @project.name, :project => {:display_name => "Build Another Death Star"}}
      response.should be_redirect
      project = @group.reload.projects.first
      project.display_name.should == "Build Another Death Star"
      project.name.should == "build+another+death+star"
    end
    
    it "should redirect if the user is not a sponsor" do
      sign_in @user2
      put :update, {:permalink => @group.permalink, :name => @project.name, :project => {:display_name => "Build Another Death Star"}}
      response.should redirect_to("/")
    end
  end

end