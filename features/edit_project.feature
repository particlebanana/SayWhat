@project
Feature: Edit a project

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And I am an "adult sponsor"
    And there is a project named "Build The Death Star"

  Scenario: I want to edit a project
    Given I am on my groups projects page
    Then I should see "Build The Death Star"
    Then I follow "Build The Death Star"
    Then I follow "edit"
    And I fill in the following:
      | project_display_name  | Build Another Death Star    |
    And I press "Save Project"
    Then I should see "Build Another Death Star" within the page title
    
  
  Scenario: I upload a project image
    Given I am on my groups projects page
    Then I follow "Build The Death Star"
    Then I follow "edit"
    And I select a project photo to attach
    And I press "Save Project"
    Then I should see an image