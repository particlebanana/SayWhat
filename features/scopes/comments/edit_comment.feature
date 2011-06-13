@comment
Feature: Edit a comment I left as a member

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And there is a project named "Build The Death Star"
    And there is a comment on the project

  Scenario: I want to edit my comment
    Given I am on the project page
    Then I should see "What planet will be destroyed first?" within "#comments"
    Then I should see "edit"
    And I should see "Han Solo"
    And I follow "edit" within ".commentBody"
    Then I should see "Edit Comment" 
    And I should see "What planet will be destroyed first?"
    And I fill in the following:
      | comment_comment  | This is an updated comment    |
    And I press "Update Comment"
    Then I should see "Comment has been updated"