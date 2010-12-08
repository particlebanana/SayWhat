
# Create a project with the give name
Given /^there is a project named "([^"]*)"$/ do |name|
  create_project(name)
end

# Seed each group with x projects
Given /^each group has "([^"]*)" project$/ do |count|
  groups = Group.all
  groups.each do |group|
    count.to_i.times do |i|
      project = Factory.build(:project, :display_name => "Project_" + i.to_s)
      group.projects << project
      project.save!
      group.save!
    end
  end
end
