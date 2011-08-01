@group
@membership
Feature: Request to join a group

  Background: 
    Given I am not logged in
    And there is a group named "Han Shot First"

  Scenario: I request to join a group
    When I go to the request group membership page
    And I fill in the following:
      | user_first_name             | Bobba                 |
      | user_last_name              | Fett                  |
      | user_email                  | bobba.fett@gmail.com  |
      | user_password               | test1234              |
      | user_password_confirmation  | test1234              |
    When I press "Submit Request"
    Then I should see "Request Was Sent For Approval"
    And I should receive an email at "bobba.fett@gmail.com" with the subject "Your membership to Han Shot First on SayWhat! is awaiting approval"
    
    
  Scenario: I request to join a group with an email that's already taken
    Given a user exists with an email "bobba.fett@gmail.com"
    When I go to the request group membership page
    And I fill in the following:
      | user_first_name             | Bobba                 |
      | user_last_name              | Fett                  |
      | user_email                  | bobba.fett@gmail.com  |
      | user_password               | test1234              |
      | user_password_confirmation  | test1234              |
    When I press "Submit Request"
    Then I should not see "Request Was Sent For Approval"
  
  
  Scenario: I request to join a group and don't include a password
    When I go to the request group membership page
    And I fill in the following:
      | user_first_name             | Bobba                 |
      | user_last_name              | Fett                  |
      | user_email                  | bobba.fett@gmail.com  |
    When I press "Submit Request"
    Then I should not see "Request Was Sent For Approval"