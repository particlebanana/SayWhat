
# Create a project with the give name
Given /^there is a project named "([^"]*)"$/ do |name|
  create_project(name)
end