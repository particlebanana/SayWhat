@group
Feature: Request to be a start a new group

  Background: 
    Given I am not logged in

  Scenario: I request to start a new group
    When I go to the request new group page
    And I fill in the following:
      | group_display_name                | The Rebel Alliance     |
      | group_city                        | Galactic City          |
      | group_organization                | New Galactic Republic  |
      | group_permalink                   | rebel-alliance         |
      | group_user_first_name             | Luke                   |
      | group_user_last_name              | Skywalker              |
      | group_user_email                  | l.skywalker@gmail.com  |
      | group_user_password               | test1234               |
      | group_user_password_confirmation  | test1234               |
    When I press "Create Group"
    Then I should see "Your request has been sent for approval. You should hear back soon."
    And I should receive an email at "l.skywalker@gmail.com" with the subject "Your group on SayWhat! is awaiting approval"
    
    
  Scenario: I request to start a new group with a name that's already taken
    Given a group exists with a display_name of "The Rebel Alliance"
    When I go to the request new group page
    And I fill in the following:
      | group_display_name                | The Rebel Alliance     |
      | group_city                        | Galactic City          |
      | group_organization                | New Galactic Republic  |
      | group_permalink                   | rebel-alliance         |
      | group_user_first_name             | Luke                   |
      | group_user_last_name              | Skywalker              |
      | group_user_email                  | l.skywalker@gmail.com  |
      | group_user_password               | test1234               |
      | group_user_password_confirmation  | test1234               |
    When I press "Create Group"
    Then I should not see "Your request has been sent for approval. You should hear back soon."