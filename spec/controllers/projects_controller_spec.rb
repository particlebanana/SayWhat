require 'spec_helper'

describe ProjectsController do
  before do
    @group = Factory.create(:group)
    @project = Factory.create(:project, { group: @group } )
  end
 
  describe "#index" do
    before { get :index, { group_id: @group.permalink } }
    
    it "should return an array of Group objects" do
      assigns[:projects].count.should == 1
      (assigns[:projects].is_a? Array).should be_true
    end
  
    it "should render the index template" do
      response.should render_template('projects/index')      
    end
  end
  
  describe "#show" do
    before { get :show, { group_id: @group.permalink, id: @project.id } }
    
    it "should return a Project object" do
      (assigns[:project].is_a? Project).should be_true
    end
        
    it "should render the show template" do
      response.should render_template('projects/show')
    end
  end
  
  describe "#new" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        get :new, { group_id: @group.permalink }
      end
      
      it "should return a Project object" do
        (assigns[:project].is_a? Project).should be_true
      end
    
      it "should render the new template" do
        response.should render_template('projects/new')
      end
    end
    
    context "non group member" do
      before do
        user = Factory.create(:user)
        sign_in user
        get :new, { group_id: @group.permalink }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end
  
  describe "#create" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        project = Factory.build(:project, { display_name: "test", group: @group } )
        post :create, { group_id: @group.permalink, project: project.attributes }
        @demo = Project.where(display_name: "test").first
      end
      
      it "should create group project" do
        @group.projects.count.should == 2
      end
      
      it "should redirect to the show action" do
        response.should redirect_to("/groups/#{@group.permalink}/projects/#{@demo.id}")
      end
      
      subject { flash[:notice] }
      it { should  =~ /project was added successfully/i }
    end
    
    context "non-group member" do
      before do
        user = Factory.create(:user)
        sign_in user
        project = Factory.build(:project, { display_name: "test", group: @group } )
        post :create, { group_id: @group.permalink, project: project.attributes }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    context "another group's member" do
      before do
        group = Factory.create(:group, { display_name: "test other group", permalink: "blah blah" } )
        user = Factory.create(:user, { group: group, role: 'member' } )
        sign_in user
        project = Factory.build(:project, { display_name: "test", group: @group } )
        post :create, { group_id: @group.permalink, project: project.attributes }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end

  describe "#edit" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        get :edit, { group_id: @group.permalink, id: @project.id }
      end
    
      it "should return a Project object" do
        (assigns[:project].is_a? Project).should be_true
      end
        
      it "should render the edit template" do
        response.should render_template('projects/edit')
      end
    end
    
    context "non-group member" do
      before do
        user = Factory.create(:user)
        sign_in user
        get :edit, { group_id: @group.permalink, id: @project.id }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    context "another group's member" do
      before do
        group = Factory.create(:group, { display_name: "test other group", permalink: "blah blah" } )
        user = Factory.create(:user, { group: group, role: 'member' } )
        sign_in user
        get :edit, { group_id: @group.permalink, id: @project.id }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end

  describe "#update" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        put :update, { group_id: @group.permalink, id: @project.id, project: { display_name: "test update" } }
      end
      
      it "should update display name" do
        @project.reload.display_name.should == "test update"
      end
      
      it "should redirect to the show action" do
        response.should redirect_to("/groups/#{@group.permalink}/projects/#{@project.id}")
      end
      
      subject { flash[:notice] }
      it { should  =~ /project has been updated/i }
    end
    
    context "non-group member" do
      before do
        user = Factory.create(:user)
        sign_in user
        put :update, { group_id: @group.permalink, id: @project.id, project: { display_name: "test update" } }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    context "another group's member" do
      before do
        group = Factory.create(:group, { display_name: "test other group", permalink: "blah blah" } )
        user = Factory.create(:user, { group: group, role: 'member' } )
        sign_in user
        put :update, { group_id: @group.permalink, id: @project.id, project: { display_name: "test update" } }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end

  describe "#destroy" do
    context "group adult sponsor" do
      before do
        user = Factory.create(:user, { group: @group, role: 'adult sponsor' } )
        sign_in user
        delete :destroy, { group_id: @group.permalink, id: @project.id }
      end
      
      it "should remove project from group" do
        @group.projects.count.should == 0
      end
      
      it "should redirect to index page" do
        response.should redirect_to("/groups/#{@group.permalink}/projects")
      end
      
      subject { flash[:notice] }
      it { should  =~ /project has been deleted/i }
    end
    
    context "group youth sponsor" do
      before do
        user = Factory.create(:user, { group: @group, role: 'youth sponsor' } )
        sign_in user
        delete :destroy, { group_id: @group.permalink, id: @project.id }
      end
      
      it "should remove project from group" do
        @group.projects.count.should == 0
      end
      
      it "should redirect to index page" do
        response.should redirect_to("/groups/#{@group.permalink}/projects")
      end
      
      subject { flash[:notice] }
      it { should  =~ /project has been deleted/i }
    end
    
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group, role: 'member' } )
        sign_in user
        delete :destroy, { group_id: @group.permalink, id: @project.id }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    context "another group's sponsor" do
      before do
        group = Factory.create(:group, { display_name: "test other group", permalink: "blah blah" } )
        user = Factory.create(:user, { group: group, role: 'adult sponsor' } )
        sign_in user
        delete :destroy, { group_id: @group.permalink, id: @project.id }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end
end