require 'spec_helper'

describe ProjectsController do
  before(:each) do
    build_group_with_admin
  end
  
  describe "#create" do
        
    it "should add a project to a group" do 
      sign_in @user
      project = {
        :permalink => @group.permalink,
        :project => {
          :display_name =>  "Build Death Star",
          :location => "Outer Space",
          :start_date => "11-11-2011",
          :end_date => "11-12-2011",
          :focus => "Alderaan",
          :audience => "People of Aldreaan...for a flash",
          :goal => "Destroy planets",
          :involves => "Stormtroopers, Sith Lords, Vader, A Big Laser",
          :description => "A Top Secret project"
        }
      }
  
      post :create, project
      response.should be_redirect
      @group.reload.projects.count.should == 1
    end
        
  end
  
  describe "#index" do
    before do
      sign_in @user
    end
    
    it 'returns all a groups projects' do
      get :index, :permalink => @group.permalink
      assigns[:projects].should == @group.projects
    end

  end
  
  describe "#edit" do
    before(:each) do
      build_project
      @another_user = seed_additional_group
    end
    
    it "should allow a group adult sponsor to edit" do
      sign_in @admin
      get :edit, :permalink => @group.permalink, :name => @project.name
      response.should render_template("projects/edit")
    end
    
    it "should not allow a member of another group to edit" do
      sign_in @another_user
      get :edit, :permalink => @group.permalink, :name => @project.name
      response.should redirect_to("/")
    end
      
  end
  
  describe "#update" do
    before do
      build_project
    end
    
    it "should update a project with new values" do
      sign_in @admin
      put :update, {:permalink => @group.permalink, :name => @project.name, :project => {:display_name => "Build Another Death Star"}}
      response.should be_redirect
      project = @group.reload.projects.first
      project.display_name.should == "Build Another Death Star"
      project.name.should == "build+another+death+star"
    end
    
    it "should redirect if the user is not a sponsor" do
      sign_in @user
      put :update, {:permalink => @group.permalink, :name => @project.name, :project => {:display_name => "Build Another Death Star"}}
      response.should redirect_to("/")
    end
    
  end
  
  describe "#all" do
    before(:each) do
      build_project
      seed_additional_group
      sign_in @user
    end
    
    it "should list all the projects in the system" do
      get :all
      assigns[:projects].count.should == 2
    end
    
    it "should render the global projects list" do
      get :all
      response.should render_template('projects/all')
    end
  end

end