Given /^there is a pending group named "([^"]*)"$/ do |name|
  create_pending_group(name)
end

Given /^there is a group named "([^"]*)"$/ do |name|
  create_group(name)
end

# Create multiple groups
Given /^there are (\d+) groups in the system$/ do |num|
  (num.to_i - 1).times do |count|
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
  @group.status.should == "active"
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



