@admin
Feature: Update a group

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a group named "Han Shot First"

  Scenario: I update a groups record
    When I go to the admin groups page
    Then I should see "Han Shot First"
    And I follow "Han Shot First"
    Then I should see "Sponsor Name: Han Solo"
    And I fill in the following:
      | group_display_name  | Han Shot Second     |
    And I press "Update"
    Then I should see "Han Shot Second" 
