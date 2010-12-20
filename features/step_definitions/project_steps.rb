
# Create a project with the give name
Given /^there is a project named "([^"]*)"$/ do |name|
  create_project(name)
end

Given /^the project has already happened$/ do
  @project.start_date = Date.today - 2.days
  @project.end_date = Date.today - 1.day
  @project.save
end

Given /^the project has not happened yet$/ do
  @project.start_date = Date.today
  @project.end_date = Date.today + 2.days
  @project.save
end

Given /^the project has been reported on$/ do
  @report = Factory.build(:report)
  @project.report = @report
  @report.save
end


# Seed each group with x projects
Given /^each of the groups have (\d+) projects$/ do |count|
  time = 1
  focus_array = ['Secondhand Smoke Exposure', 'General Education', 'Health Effects']
  audience_array = ['Elementary Students', 'Middle School Students', 'High School Students']
  @groups.each do |group|
    count.to_i.times do |i|
      project = Factory.build(:project, :display_name => "Project_" + (time + i).to_s, :focus => focus_array[i], :audience => audience_array[i])
      group.projects << project
      project.save!
    end
    group.save!
    time += 1
  end
end

# Seed each group with x completed projects
Given /^each of the groups have (\d+) completed projects$/ do |count|
  time = 1
  focus_array = ['Secondhand Smoke Exposure', 'General Education', 'Health Effects']
  audience_array = ['Elementary Students', 'Middle School Students', 'High School Students']
  @groups.each do |group|
    count.to_i.times do |i|
      project = Factory.build(:project, :display_name => "Project_" + (time + i).to_s, :focus => focus_array[i], :audience => audience_array[i])
      project.start_date = Date.today - 2.days
      project.end_date = Date.today - 1.day
      group.projects << project
      project.save!
    end
    group.save!
    time += 1
  end
end

# Seed each group with x upcoming projects
Given /^each of the groups have (\d+) upcoming project$/ do |count|
  time = ProjectCache.all.count
  focus_array = ['Secondhand Smoke Exposure', 'General Education', 'Health Effects']
  audience_array = ['Elementary Students', 'Middle School Students', 'High School Students']
  @groups.each do |group|
    count.to_i.times do |i|
      project = Factory.build(:project, :display_name => "Project_" + (time + i).to_s, :focus => focus_array[i], :audience => audience_array[i])
      project.start_date = Date.today
      project.end_date = Date.today + 1.day
      group.projects << project
      project.save!
    end
    group.save!
    time += 1
  end
end



# Count all projects returned from the filter search
Then /^I should see (\d+) projects$/ do |num|
  all('ul.projectsList li').length.should == num.to_i
end

# Add an image to the project
Given /^I select a project photo to attach$/ do
  attach_file('project_profile_photo', "#{Rails.root}/features/fixtures/profile.png")
end
