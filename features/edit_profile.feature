@user
Feature: Edit a user's profile

  Background: 
    Given I am logged in

  Scenario: I want to edit my user profile information
    Given I am on my profile settings page
    And I fill in the following:
      | user_first_name  |  Jabba     |
      | user_last_name   |  The Hut   |
    And I press "Save"
    Then I should see "Jabba The Hut" within the page header
    
    
  Scenario: I remove required information from my profile
    Given I am on my profile settings page
    And I fill in the following:
      | user_first_name  |  Jabba     |
      | user_last_name   |  The Hut   |
      | user_email       |            |
    And I press "Save"
    Then I should see "Email can't be blank"
    