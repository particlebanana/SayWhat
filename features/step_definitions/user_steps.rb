# Ensure Logged In
Given /^I am logged in$/ do
  And %{I go to the login page}
  And %{I fill in "user_email" with "#{@user.email}"}
  And %{I fill in "user_password" with "#{@user.password}"}
  And %{I press "Sign in"}
end

Given /^I am logged in as "([^"]*)"$/ do |email|
  @user = create_user(email)
  And %{I go to the login page}
  And %{I fill in "user_email" with "#{@user.email}"}
  And %{I fill in "user_password" with "#{@user.password}"}
  And %{I press "Sign in"}
end

Given /^there is a "([^"]*)" with the email "([^"]*)"$/ do |role, email|
  @user = Factory.build(:user, :email => email, :first_name => "Luke", :last_name => "Skywalker")
  @user.status = 'active'
  @user.role = role
  @group.users << @user
  @user.save!
  @group.save!
end

# Add user to group
Given /^I belong to the group$/ do
  @user.group = @group
  @user.save
end


Given /^I am a group sponsor$/ do
  @user.role = "adult sponsor"
  @user.save!
end

Given /^I am an "([^"]*)"$/ do |role|
  @user.role = role
  @user.save!
end


# Ensure NOT Logged In
Given /^I am not logged in$/ do
  visit('/users/sign_out') # ensure that at least
end

Given /^I am a Site Admin$/ do
  @user = Factory.build(:user, :first_name => "Bobba", :last_name => "Fett")
  @user.role = "admin"
  @user.status = "active"
  @user.save!
end


Given /^I am an 'Adult Sponsor'$/ do
  @user.adult_sponsor?
end


# Login using email and password parameters
Given /^I login using "([^"]*)" and "([^"]*)"$/ do |email, password|
  And %{I go to the login page}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign in"}
end

# Edit User Profile
Given /^I select an avatar to attach$/ do
  attach_file('user_avatar', "#{Rails.root}/features/fixtures/default.png")
end

Then /^I should see an image$/ do
  page.should have_css("img")
end

# Request Group Membership
Given /^there is a pending member$/ do
  user = Factory.build(:user_input, :email => "billy.bob.jo@gmail.com")
  user.status = 'pending'
  user.role = 'pending'
  @group.users << user
  user.save!
  @group.save
  @user.create_message_request_object(user.name, user.email, user.id.to_s)
end

Given /^a user exists with an email "([^"]*)"$/ do |email|
  group = Factory.build(:group, :display_name => 'Rebel Alliance')
  group.status = 'active'
  user = Factory.build(:user, :email => email)
  user.status = 'active'
  user.role = 'adult sponsor'
  group.users << user
  user.save
  group.save
end

Then /^the member should be approved$/ do
  @group = Group.find(:first, :conditions => {:display_name => "Han Shot First"})
  @group.users.last.status.should == "setup"
end

Given /^I follow the member setup link that was emailed to me$/ do
  create_setup_user
  visit setup_member_user_path(:id => @user.id, :auth_token => @user.authentication_token)
end
