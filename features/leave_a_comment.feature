@comment
Feature: Leave a comment on a project

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And there is a project named "Build The Death Star"

  Scenario: I want to comment on a project
    Given I am on the project page
    Then I fill in the following:
      | comment_comment      | What planet is first?     |
    And I press "Leave Comment"
    Then I should see "Comment successfully posted"
    
