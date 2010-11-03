Given /^I am logged in$/ do
  current_user 
end

Given /^I am not logged in$/ do
  !current_user
end

Given /^I am a 'Site Admin'$/ do
  pending # express the regexp above with the code you wish you had
end