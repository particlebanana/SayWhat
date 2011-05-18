@admin
Feature: Update a user

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a group named "Han Shot First"
    And there is a group member with the email "luke.skywalker@gmail.com"

  Scenario: I update a user's record
    When I go to the users listing page
    Then I should see "Luke Skywalker"
    And I follow "Luke Skywalker"
    Then I should see "User Info"
    And I fill in the following:
      | user_first_name  | Yoda      |
      | user_last_name   | Skywalker |
    And I press "Update"
    Then I should see "User has been updated" 
