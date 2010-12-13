require 'spec_helper'

describe ProjectsController do
  before(:each) do
    build_group_with_admin
  end
  
  describe "#create" do
    before(:each) do
      @another_user = seed_additional_group
    end
        
    it "should add a project to a group" do 
      sign_in @user
      project = build_project_params
      post :create, project
      response.should be_redirect
      @group.reload.projects.count.should == 1
    end
    
    it "should not allow a member of another group to create a project" do
      sign_in @another_user
      project = build_project_params
      post :create, project
      response.should redirect_to("/")
      @group.reload.projects.count.should == 0
    end
        
  end
  
  describe "#index" do
    before do
      sign_in @user
    end
    
    it 'returns all of a groups projects' do
      get :index, :permalink => @group.permalink
      assigns[:projects].count.should == @group.projects.count
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
  
  describe "#filter" do
    before(:each) do
      seed_full_data_set
      sign_in User.first
    end
    
    it "should filter projects by focus" do
      get :filter, :focus => "Secondhand Smoke Exposure", :audience => ""
      response.should render_template('projects/all')
      assigns[:projects].count.should == 3
    end
    
    it "should filter projects by audience" do
      get :filter, :focus => "", :audience => "Middle School Students"
      response.should render_template('projects/all')
      assigns[:projects].count.should == 3
    end
    
    it "should filter projects by focus and audience" do
      get :filter, :focus => "Secondhand Smoke Exposure", :audience => "Elementary Students"
      response.should render_template('projects/all')
      assigns[:projects].count.should == 3
    end

  end

end