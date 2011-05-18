Given /^there is a pending group named "([^"]*)"$/ do |name|
  create_pending_group(name)
end

Given /^there are no pending groups$/ do
  Group.delete_all
end

Given /^there is a group named "([^"]*)"$/ do |name|
  create_group(name)
end

# Create multiple groups other than the one created by user creation
Given /^there are (\d+) other groups in the system$/ do |num|
  (num.to_i).times do |count|
    group = Factory.build(:group, :display_name => "group_" + (count.to_i).to_s, :permalink => "group_" + (count.to_i).to_s)
    admin = build_a_generic_admin(count)
    group.users << admin
    group.save!
  end
  @groups = Group.all
  assert @groups.count.should == num.to_i + 1
end

# Create multiple groups without a logged in user
Given /^there are (\d+) groups in the system$/ do |num|
  Group.delete_all # start with a clean slate
  ProjectCache.delete_all
  (num.to_i).times do |count|
    group = Factory.build(:group, :display_name => "group_" + (count.to_i).to_s, :permalink => "group_" + (count.to_i).to_s)
    admin = build_a_generic_admin(count)
    group.users << admin
    group.save!
  end
  @groups = Group.all
  assert @groups.count.should == num.to_i
end

def build_a_generic_admin(i)
  admin = Factory.build(:user, :email => "admin_" + i.to_s + "@gmail.com")
  admin.status = "active"
  admin.role = "adult sponsor"
  admin
end

Then /^the group should be approved$/ do
  @group = Group.find(@group.id)
  @group.status.should == "setup"
end

Then /^the group should be denied$/ do
  Group.where(:_id => @group.id).first.should == nil
  User.where(:group_id => @group.id).first.should == nil
end

Then /^the adult sponsor should be "([^"]*)"$/ do |sponsor_email|
  @group.reload.users.adult_sponsor.first.email.should == sponsor_email
end

Given /^I follow the group setup link that was emailed to me$/ do
  create_setup_group("Rebel Alliance")
  visit "/groups/#{@group.id}/setup?auth_token=#{@user.authentication_token}"
end

When /^I am in the permalink setup stage$/ do
  visit "/groups/#{@group.id}/setup_permalink"
end

Then /^I should have a valid permalink$/ do
  @group = Group.find(@group.id)
  @group.permalink.should_not == nil
end

# Add an image to the project
Given /^I select a group photo to attach$/ do
  attach_file('group_profile_photo', "#{Rails.root}/features/support/fixtures/profile.png")
end