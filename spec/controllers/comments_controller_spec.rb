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