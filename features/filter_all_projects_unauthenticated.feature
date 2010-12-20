@projects
@filters
Feature: View and filter all projects from all groups as a public viewer

  Background: 
    Given there are 3 groups in the system
    And each of the groups have 2 completed projects
    And each of the groups have 1 upcoming project

  Scenario: I want to view all projects
    Given I am on the all projects page
    Then I should see "Project_1" 2 times within "ul.projectsList"
    And I should see "Project_2" 2 times within "ul.projectsList"
    
  Scenario: I want to filter by the focus field
    Given I am on the all projects page
    And I select "Secondhand Smoke Exposure" from "focus"
    And I select "" from "audience"
    Then I press "Filter"
    Then I should see 3 projects
    
  Scenario: I want to filter by the audience field
    Given I am on the all projects page
    And I select "" from "focus"
    And I select "Elementary Students" from "audience"
    Then I press "Filter"
    Then I should see 3 projects
    
  Scenario: I want to filter by the focus field AND the audience field
    Given I am on the all projects page
    And I select "Secondhand Smoke Exposure" from "focus"
    And I select "Elementary Students" from "audience"
    Then I press "Filter"
    Then I should see 3 projects
    
