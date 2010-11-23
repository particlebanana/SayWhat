Given /^there is a pending group named "([^"]*)"$/ do |name|
  create_pending_group(name)
end

Given /^there is a group named "([^"]*)"$/ do |name|
  create_group(name)
end

Then /^the group should be approved$/ do
  @group = Group.find(@group.id)
  @group.status.should == "active"
end

Given /^I follow the group setup link that was emailed to me$/ do
  create_setup_group("Rebel Alliance")
  visit setup_group_path(:id => @group.id, :auth_token => @user.authentication_token)
end

When /^I am in the permalink setup stage$/ do
  visit setup_permalink_group_path(:id => @group.id)
end

Then /^I should have a valid permalink$/ do
  @group = Group.find(@group.id)
  @group.permalink.should_not == nil
end



