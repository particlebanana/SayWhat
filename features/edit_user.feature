@user
Feature: Edit a user's profile

  Background: 
    Given I am logged in as "han.solo@gmail.com"

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
    
    
  Scenario: I upload a profile image
    Given I am on my profile settings page
    And I select a file to attach
    And I press "Save"
    Then I should see an image within the form fields
    
    
  Scenario: I want to edit my password
    Given I am on my password settings page
    And I fill in the following:
      | user_password                |  thisisatest     |
      | user_password_confirmation   |  thisisatest     |
    And I press "Update"
    Then I should see "Password has been updated" within the notice
    And I am not logged in
    When I login using "han.solo@gmail.com" and "thisisatest"
    Then I should see "Han Solo" within the page header
    