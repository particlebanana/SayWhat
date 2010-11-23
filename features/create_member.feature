@user
Feature: Create a group user after is has been approved

  Background: 
    Given I am not logged in

  Scenario: I use the generated link in my email to login and create member account
    Given I follow the member setup link that was emailed to me
    And I fill in the following:
      | user_password               | testpassword     |
      | user_password_confirmation  | testpassword     |
    And I press "Continue"
    Then I should see "Evil Empire"
    
    