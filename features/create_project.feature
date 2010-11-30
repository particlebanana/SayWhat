@project
Feature: Create a new group project

  Background: 
    Given I am logged in as "han.solo@gmail.com"

  Scenario: I want to create a new project
    Given I am on my group page
    Then I follow "projects"
    Then I follow "new project"
    And I fill in the following:
      | project_display_name      | Build The Death Star     |
      | project_location          | Outer Space              |
      | project_description       | a simple description     |
    And I press "Create Project"
    Then I should see "Build The Death Star" within the page title
    
  Scenario: I create an invalid project
    Given I am on my group page
    Then I follow "projects"
    Then I follow "new project"
    And I fill in the following:
      | project_display_name      |                          |
      | project_location          | Outer Space              |
      | project_description       | a simple description     |
    And I press "Create Project"
    Then I should see "Opps, there were some problems creating your project"
    
    