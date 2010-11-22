# Ensure Logged In
Given /^I am logged in$/ do
  @user = Factory.create(:admin)
  And %{I go to the login page}
  And %{I fill in "user_email" with "#{@user.email}"}
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

# Edit User Profile
Given /^I select a file to attach$/ do
  attach_file('user_avatar', "#{Rails.root}/features/fixtures/default.png")
end

Then /^I should see an image$/ do
  page.should have_css("img")
end

