@group
Feature: Setup a group

  Background: 
    Given I am not logged in

  Scenario: I use the generated link in my email to login and create sponsor account
    Given I follow the group setup link that was emailed to me
    Then I follow "Continue"
    And I fill in the following:
      | user_password               | testpassword     |
      | user_password_confirmation  | testpassword     |
    And I press "Continue"
    Then I should see "Url"
    
  
  Scenario: I setup a permalink for my group
    Given I follow the group setup link that was emailed to me
    When I am on the permalink setup page
    And I fill in the following:
      | group_permalink   |  rebel alliance  |
    And I press "Continue"
    Then I should have a valid permalink
    And I should receive an email with the subject "Your group has been successfully setup on SayWhat!"
    