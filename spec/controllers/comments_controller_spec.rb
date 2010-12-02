require 'spec_helper'

describe CommentsController do
  before do
    build_project
    sign_in @user
  end
  
  describe "#create" do
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
  

end