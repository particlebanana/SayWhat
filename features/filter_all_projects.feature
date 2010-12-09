@project
Feature: View and filter all projects from all groups

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And there are "3" groups in the system
    And each group has "3" projects

  Scenario: I want to view all projects
    Given I am on my group page
    Then I follow "projects"
    Then I follow "everyone's projects"
    Then I should see "Project_1" 
    And I should see "Project_2" 
    And I should see "Project_3" 
    
  Scenario: I want to filter by the focus field
    Given I am on the all projects page
    And I select "Secondhand Smoke Exposure" from "focus"
    And I select "" from "audience"
    Then I press "Filter"
    Then I should see 3 projects
    
