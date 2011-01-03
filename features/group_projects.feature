@projects
Feature: View a Group's Projects
  Background: 
    Given there is a group named "Rebel Alliance"
    And there is a "member" with the email "chewbaca@gmail.com"
    And there is a project named "Build The Death Star"
    And the project has already happened
    And there is a project named "Save The Ewoks"
    And the project has not happened yet

  Scenario: A public user views the group's projects page
    Given I am on the groups projects page
    Then I should see "Build The Death Star" within Completed Projects
    And I should not see "Upcoming Projects:"
    And I should not see "Save The Ewoks"
    
    
  Scenario: A group member views the group's projects page
    Given I am logged in
    And I am on the groups projects page
    Then I should see "start a new project"
    And I should see "Build The Death Star" within Completed Projects
    And I should see "Upcoming Projects:"
    And I should see "Save The Ewoks" within Upcoming Projects
