@group
Feature: View a Group's Homepage

  Background: 
    Given there is a group named "Rebel Alliance"
    And there is a "member" with the email "chewbaca@gmail.com"
    And there is a project named "Build The Death Star"
    And the project has already happened
    And the project has been reported on

  Scenario: A public user views the group's page
    Given I am on the groups home page
    Then I should see "Request To Join This Group"
    And I should see "Build The Death Star" within Recent Projects
    And I should not see "View All"
    And I should not see "Edit"
    And I should not see "Member List"
    
  Scenario: A group member views the group's page
    Given I am logged in
    And I am on the groups home page
    Then I should see "Invite Someone To Join This Group"
    And I should see "Build The Death Star" within Recent Projects
    And I should see "View All"
    And I should not see "Edit"
    And I should see "Member List"
