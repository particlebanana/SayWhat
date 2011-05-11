@admin
Feature: Site Admin views the pending group request

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a pending group named "Han Shot First"

  Scenario: I view the list of pending groups
    When I go to the requests page
    Then I should see "All Group Requests"
    Then I should see "Han Shot First"
    And I should see "Han Solo"
    And I should see "user007@gmail.com"