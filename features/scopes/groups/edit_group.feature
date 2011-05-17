@group
Feature: Edit a group

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And I am an "adult sponsor"

  Scenario: I want to edit my groups name
    Given I am on my group page
    Then I follow "edit"
    And I fill in the following:
      | group_display_name  | Han Shot Second     |
    And I press "Update"
    Then I should see "Han Shot Second" 
    
  
  Scenario: I upload a project image
    Given I am on my group page
    Then I follow "edit"
    And I select a group photo to attach
    And I press "Update"
    Then I should see an image
    