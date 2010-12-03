# Create a comment on a project
Given /^there is a comment on the project$/ do
  @comment = Factory.build(:comment)
  @comment.user = @user
  @project.comments << @comment
  @comment.save!
  @project.save!
end
