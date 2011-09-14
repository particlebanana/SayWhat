require 'spec_helper'

describe CommentsController do
  before do
    @group = Factory.create(:group)
    @project = Factory.create(:project, { group: @group } )
  end
  
  # INDEX
  # Group Members and Registered Users can view project comments
  # Unregistered members can not view comments
  describe "#index" do    
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        get :index, { group_id: @group.permalink, project_id: @project.id }
      end
      
      it "should return an array of Comment objects" do
        assigns[:comments].is_a? Array
      end

      it "should render the index template" do
        response.should render_template('comments/index')      
      end
    end
    
    context "registered user" do
      before do
        user = Factory.create(:user)
        sign_in user
        get :index, { group_id: @group.permalink, project_id: @project.id }
      end
      
      it "should return an array of Comment objects" do
        assigns[:comments].is_a? Array
      end
    end
    
    context "public user" do
      before { get :index, { group_id: @group.permalink, project_id: @project.id } }
      subject { flash[:alert] }
      it { should  =~ /need to sign in or sign up/i }
    end
  end
  
  # NEW
  # Group Members and Registered Users can view project comment form
  # Unregistered members can not view new form
  describe "#new" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        get :new, { group_id: @group.permalink, project_id: @project.id }
      end
      
      it "should return a Comment object" do
        assigns[:comment].is_a? Comment
      end
    
      it "should render the new template" do
        response.should render_template('comments/new')
      end
    end
    
    context "registered user" do
      before do
        user = Factory.create(:user)
        sign_in user
        get :new, { group_id: @group.permalink, project_id: @project.id }
      end
      
      it "should return a Comment object" do
        assigns[:comment].is_a? Comment
      end
    end
  end
  
  # CREATE
  # Group Members and Registered Users can create project comments
  # Unregistered members can not create project comments
  describe "#create" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        post :create, { group_id: @group.permalink, project_id: @project.id, comment: { comment: "test comment" } }
      end
      
      it "should create project comment" do
        @project.comments.count.should == 1
      end
      
      it "should redirect to the project show action" do
        response.should redirect_to("/groups/#{@group.permalink}/projects/#{@project.id}")
      end
      
      subject { flash[:notice] }
      it { should  =~ /comment was added successfully/i }
    end
    
    context "registered user" do
      before do
        user = Factory.create(:user)
        sign_in user
        post :create, { group_id: @group.permalink, project_id: @project.id, comment: { comment: "test comment" } }
      end
      
      it "should create project comment" do
        @project.comments.count.should == 1
      end
    end
  end
  
  # EDIT
  # Group Members and Registered Users can view project comment edit form
  # Unregistered members can not view project comment edit form
  describe "#edit" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        @comment = Factory.create(:comment, { user_id: user.id, project_id: @project.id } )
        get :edit, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
    
      it "should return a Comment object" do
        assigns[:comment].is_a? Comment
      end
        
      it "should render the edit template" do
        response.should render_template('comments/edit')
      end
    end
    
    context "registered user" do
      before do
        user = Factory.create(:user)
        sign_in user
        @comment = Factory.create(:comment, { user_id: user.id, project_id: @project.id } )
        get :edit, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
      
      it "should return a Comment object" do
        assigns[:comment].is_a? Comment
      end
    end
  end
  
  # UPDATE
  # Group Members and Registered Users can update their own project comment
  # Unregistered members can not update any project comments
  describe "#update" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        @comment = Factory.create(:comment, { user_id: user.id, project_id: @project.id } )
        put :update, { group_id: @group.permalink, project_id: @project.id, id: @comment.id, comment: "test update" }
      end
      
      it "should update comment text" do
        @comment.reload.comment.should == "test update"
      end
      
      it "should redirect to the project show action" do
        response.should redirect_to("/groups/#{@group.permalink}/projects/#{@project.id}")
      end
      
      subject { flash[:notice] }
      it { should  =~ /comment has been updated/i }
    end
    
    context "registered user" do
      before do
        user = Factory.create(:user)
        sign_in user
        @comment = Factory.create(:comment, { user_id: user.id, project_id: @project.id } )
        put :update, { group_id: @group.permalink, project_id: @project.id, id: @comment.id, comment: "test update" }
      end
      
      it "should update comment text" do
        @comment.reload.comment.should == "test update"
      end
    end
    
    context "group member - others comment" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        user2 = Factory.create(:user, { group: @group, email: 'user2@gmail.com' } )
        @comment = Factory.create(:comment, { user_id: user2.id, project_id: @project.id } )
        put :update, { group_id: @group.permalink, project_id: @project.id, id: @comment.id, comment: "test update" }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end
  
  # DESTROY
  # Group Members and Registered Users can destory their own project comment
  # Unregistered members can not destroy any project comments
  # Group Sponsors can delete any comments in their group
  describe "#destroy" do
    context "group member" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        @comment = Factory.create(:comment, { user_id: user.id, project_id: @project.id } )
        delete :destroy, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
      
      it "should remove comment from project" do
        @project.comments.count.should == 0
      end
      
      it "should redirect to project show page" do
        response.should redirect_to("/groups/#{@group.permalink}/projects/#{@project.id}")
      end
      
      subject { flash[:notice] }
      it { should  =~ /comment has been deleted/i }
    end
    
    context "registered user" do
      before do
        user = Factory.create(:user)
        sign_in user
        @comment = Factory.create(:comment, { user_id: user.id, project_id: @project.id } )
        delete :destroy, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
      
      it "should remove comment from project" do
        @project.comments.count.should == 0
      end
    end
    
    context "group member - others comment" do
      before do
        user = Factory.create(:user, { group: @group } )
        sign_in user
        user2 = Factory.create(:user, { group: @group, email: 'user2@gmail.com' } )
        @comment = Factory.create(:comment, { user_id: user2.id, project_id: @project.id } )
        delete :destroy, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    context "group adult sponsor - others comment" do
      before do
        user = Factory.create(:user, { group: @group, role: 'adult sponsor' } )
        sign_in user
        user2 = Factory.create(:user, { group: @group, email: 'user2@gmail.com' } )
        @comment = Factory.create(:comment, { user_id: user2.id, project_id: @project.id } )
        delete :destroy, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
      
      it "should remove comment from project" do
        @project.comments.count.should == 0
      end
    end
    
    context "other group's adult sponsor" do
      before do
        group = Factory.create(:group, { display_name: 'other group', permalink: 'other-group' } )
        user = Factory.create(:user, { group: group, role: 'adult sponsor' } )
        sign_in user
        user2 = Factory.create(:user, { group: @group, email: 'user2@gmail.com' } )
        @comment = Factory.create(:comment, { user_id: user2.id, project_id: @project.id } )
        delete :destroy, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
    
    context "group youth sponsor - others comment" do
      before do
        user = Factory.create(:user, { group: @group, role: 'youth sponsor' } )
        sign_in user
        user2 = Factory.create(:user, { group: @group, email: 'user2@gmail.com' } )
        @comment = Factory.create(:comment, { user_id: user2.id, project_id: @project.id } )
        delete :destroy, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
      
      it "should remove comment from project" do
        @project.comments.count.should == 0
      end
    end
    
    context "other group's youth sponsor" do
      before do
        group = Factory.create(:group, { display_name: 'other group', permalink: 'other-group' } )
        user = Factory.create(:user, { group: group, role: 'youth sponsor' } )
        sign_in user
        user2 = Factory.create(:user, { group: @group, email: 'user2@gmail.com' } )
        @comment = Factory.create(:comment, { user_id: user2.id, project_id: @project.id } )
        delete :destroy, { group_id: @group.permalink, project_id: @project.id, id: @comment.id }
      end
      
      subject { flash[:alert] }
      it { should  =~ /not authorized to access this page/i }
    end
  end
end