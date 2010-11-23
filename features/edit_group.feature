@group
Feature: Edit a group

  Background: 
    Given I am logged in as "han.solo@gmail.com"

  Scenario: I want to edit my groups name
    Given I am on my group page
    Then I follow "admin"
    And I fill in the following:
      | group_display_name  | Han Shot Second     |
    And I press "Update"
    Then I should see "Han Shot Second" within the page title
    