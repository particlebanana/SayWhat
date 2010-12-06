require 'spec_helper'

describe CommentsController do
  before do
    build_group_with_admin
    build_project
  end
  
  describe "#create" do
    before do
      sign_in @user
    end
    
    it "should add a comment to a project" do 
      comment = {
        :permalink => @group.permalink,
        :name => @project.name,
        :comment => {
          :comment =>  "What planet will be first?"
        }
      }
  
      post :create, comment
      response.should be_redirect
      project = @group.reload.projects.first
      project.comments.count.should == 1
      project.comments.first.user.name.should == "Han Solo"
    end
    
  end
  
  describe "#edit" do
    before(:each) do
      add_comment
    end
    
    it "should allow the comment user to edit" do
      sign_in @user
      get :edit, :permalink => @group.permalink, :name => @project.name, :comment_id => @comment.id.to_s
      response.should be_success 
    end
    
    it "should block editing others comments" do
      sign_in @admin
      get :edit, :permalink => @group.permalink, :name => @project.name, :comment_id => @comment.id.to_s
      response.should be_redirect
    end
    
  end
  
  describe "#update" do
    before(:each) do
      add_comment
    end
    
    it "should allow the comment user to update their comment" do
      sign_in @user
      comment_params = build_comment_params
      put :update, comment_params
      response.should be_redirect
      project = @group.reload.projects.first
      project.comments.first.comment.should == "This is an updated comment"
    end
    
    it "should not allow the comment to be updated by someone who didn't write it" do
      sign_in @admin
      comment_params = build_comment_params
      put :update, comment_params
      response.should be_redirect
      project = @group.reload.projects.first
      project.comments.first.comment.should_not == "This is an updated comment"
    end
    
    it "should not allow a user to submit a blank comment" do
      sign_in @user
      comment_params = build_comment_params
      comment_params[:comment][:comment] = ""
      put :update, comment_params
      response.should render_template('comments/edit')
    end
  end
  
  describe "#destroy" do
    before(:each) do
      add_comment
    end
    
    it "should allow the group sponsor to delete" do
      sign_in @admin
      delete :destroy, :permalink => @group.permalink, :name => @project.name, :comment_id => @comment.id.to_s
      @group.reload.projects.first.comments.find(@comment.id).should == nil
      @group.reload.projects.first.comments.count.should == 0
    end
    
    it "should not allow a group member to delete" do
      sign_in @user
      delete :destroy, :permalink => @group.permalink, :name => @project.name, :comment_id => @comment.id.to_s
      response.should be_redirect
      @group.reload.projects.first.comments.count.should == 1
    end
    
  end
  
end