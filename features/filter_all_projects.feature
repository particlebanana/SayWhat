@project
Feature: View and filter all projects from all groups

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And there are "3" groups in the system
    And each group has "1" project

  Scenario: I want to view all projects
    Given I am on my group page
    Then I follow "projects"
    Then I follow "everyone's projects"
    Then I should see "Project_0" 
    And I should see "Project_0" 
    And I should see "Project_0" 
    
