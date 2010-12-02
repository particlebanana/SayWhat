require 'spec_helper'

describe Comment do
  
  describe "validations" do
    before do
      build_group_with_admin
      @project = Factory.build(:project)
      @group.projects << @project
      @project.save!
      @group.save!
    end
    
    describe "of required fields" do 
      it "should allow a comment to be created" do
        @comment = Factory.build(:comment)
        @comment.user = @admin
        @project.comments << @comment
        @comment.should be_valid
      end
          
      it "should fail if comment field is blank" do
        @comment = Factory.build(:comment, :comment => "")
        @comment.user = @admin
        @project.comments << @comment
        @comment.should_not be_valid
      end
      
    end
    
  end
  
end