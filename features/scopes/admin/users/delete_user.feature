@admin
@delete_user
Feature: Delete a user

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a group named "Han Shot First"

  Scenario: I delete a user with the role member
    Given there is a "member" with the email "luke.skywalker@gmail.com"
    When I go to the users listing page
    Then I should see "Luke Skywalker"
    And I follow "Luke Skywalker"
    Then I should see "User Info"
    And I follow "Delete"
    Then I should see "User has been deleted"
    And I should not see "luke.skywalker@gmail.com" 
    
  Scenario: I delete a user with the role adult sponsor
    Given there is a "adult sponsor" with the email "luke.skywalker@gmail.com"
    When I go to the users listing page
    Then I should see "Luke Skywalker"
    And I follow "Luke Skywalker"
    Then I should see "User Info"
    And I follow "Delete"
    Then I should see "Must assign a new adult sponsor before you can delete this user"
