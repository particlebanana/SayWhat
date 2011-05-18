@admin
@sponsor_assign
Feature: Site Admin manually assigns a new sponsor

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a group named "Han Shot First"
    And there is a group member with the email "student@gmail.com"

  @javascript
  Scenario: I assign another group user to be a groups adult sponsor 
    When I go to the admin groups page
    Then I should see "Han Shot First"
    And I follow "Han Shot First"
    Then I should see "Sponsor Name: Han Solo"
    And I should see "assign new sponsor"
    When I follow "assign new sponsor"
    And I select "Luke Skywalker" from "members"
    And I follow "Promote Member"
    Then the adult sponsor should be "student@gmail.com"