# Ensure Logged In
Given /^I am logged in$/ do
  @user = Factory.create(:admin)
  And %{I go to the login page}
  And %{I fill in "user_username" with "#{@user.username}"}
  And %{I fill in "user_password" with "#{@user.password}"}
  And %{I press "Sign in"}
end

# Ensure NOT Logged In
Given /^I am not logged in$/ do
  visit('/users/sign_out') # ensure that at least
end

Given /^I am a 'Site Admin'$/ do
  @user.admin?
end