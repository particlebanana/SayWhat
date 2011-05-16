Given /^there is an active grant application for "([^"]*)"$/ do |group_name|
  @grant = Factory.create(:minigrant, :group_name => group_name, :status => true)
end

Given /^there is a pending grant application for "([^"]*)"$/ do |group_name|
  @grant = Factory.create(:minigrant, :group_name => group_name, :status => false)
end

Given /^there are no active grant applications$/ do
  Grant.delete_all
end

Given /^there are no pending grant applications$/ do
  Grant.delete_all
end

Then /^the grant application should be approved$/ do
  @grant.reload.status.should == true
end