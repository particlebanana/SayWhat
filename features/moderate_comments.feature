@comment
Feature: Moderate comments as a group sponsor

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And I am an "adult sponsor"
    And there is a project named "Build The Death Star"
    And there is a comment on the project

  Scenario: I to delete an inappropriate comment
    Given I am on the project page
    And I am a group sponsor
    Then I should see "What planet will be destroyed first?" within "#comments"
    And I follow "delete"
    Then I should see "Comment has been removed"
    
