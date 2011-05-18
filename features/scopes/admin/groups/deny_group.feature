@admin
Feature: Site Admin denies a group

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a pending group named "Han Shot First"

  @javascript
  Scenario: I deny a group
    When I go to the requests page
    Then I should see "Han Shot First"
    And I follow "Han Shot First"
    Then I should see "Sponsor Name: Han Solo"
    And I should see "Sponsor Email: user007@gmail.com"
    And I follow "Deny"
    Then I should see "Are you sure you want to deny this group?"
    And I select "Incorrect age group" from "deniedReasons"
    And I follow "Deny Group"
    Then the group should be denied
    And The "adult sponsor" should receive an email at "user007@gmail.com" with the subject "Your group has been denied on SayWhat!"