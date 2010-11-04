@groups
Feature: Request to be a group sponsor

  Background: 
    Given I am not logged in

  Scenario: I request to start a new group
    When I go to the request new group page
    And I fill in the following:
      | group_name               | The Rebel Alliance     |
      | group_city               | Galactic City          |
      | group_organization       | New Galactic Republic  |
      | group_user_first_name    | Luke                   |
      | group_user_last_name     | Skywalker              |
      | group_user_username      | lukeskywalker          |
      | group_user_email         | l.skywalker@gmail.com  |
    When I press "Submit Request"
    Then I should see "Request Was Sent For Approval"
    
    
  Scenario: I request to start a new group with a name that's already taken
    Given a group exists with a name of "The Rebel Alliance"
    When I go to the request new group page
    And I fill in the following:
      | group_name               | The Rebel Alliance     |
      | group_city               | Galactic City          |
      | group_organization       | New Galactic Republic  |
      | group_user_first_name    | Luke                   |
      | group_user_last_name     | Skywalker              |
      | group_user_username      | lukeskywalker          |
      | group_user_email         | l.skywalker@gmail.com  |
    When I press "Submit Request"
    Then I should not see "Request Was Sent For Approval"