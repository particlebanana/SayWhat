When /^(.*) within ([^:"]+)$/ do |step, scope|
  with_scope(selector_for(scope)) do
    When step
  end
end

# Multi-line version of above
When /^(.*) within ([^:"]+):$/ do |step, scope, table_or_string|
  with_scope(selector_for(scope)) do
    When "#{step}:", table_or_string
  end
end  


Then /^I should receive an email at "([^"]*)" with the subject "([^"]*)"$/ do |email, subject|
  emails = ActionMailer::Base.deliveries
  emails.include?(email)
  emails.include?(subject)
end

Then /^I should receive an email with the subject "([^"]*)"$/ do |subject|
  @email = ActionMailer::Base.deliveries.last
  @email.from.should == ["admin@example.com"]
  @email.to.should == [@user.email]
  @email.subject.should include(subject)
end

Then /^The "([^"]*)" should receive an email at "([^"]*)" with the subject "([^"]*)"$/ do |person, email, subject|
  emails = ActionMailer::Base.deliveries
  emails.include?(email)
  emails.include?(subject)
end

Then /^I should see "([^"]*)" (\d+) times within "([^"]*)"$/ do |text, count, selector|
  page.find(:css, selector, :count => count, :text => text)
end