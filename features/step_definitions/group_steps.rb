Given /^there is a pending group named "([^"]*)"$/ do |name|
  @group = Factory(:pending_group)
  @user = Factory(:pending_user)
  @group.users << @user
  @group.save
end

Then /^the group should be approved$/ do
  @group = Group.find(@group.id)
  @group.status.should == "active"
end



