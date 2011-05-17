@project
Feature: View a project page

  Background: 
    Given there is a group named "Wookies United"
    And there is a project named "Rebuild The Falcon"

  Scenario: A public user views the project page
    Given the project has already happened
    And I am on the project page
    Then I should see "Rebuild The Falcon"
    And I should see "Wookies United"
    And I should not see "Discussion"
    And I should not see "edit"
    
  Scenario: A group member views the project page
    Given I am logged in
    And the project has not happened yet
    And I am on the project page
    Then I should see "Rebuild The Falcon"
    Then I should see "Wookies United"
    And I should see "Discussion"
    And I should see "edit"
    
  Scenario: A public user tries to view an upcoming project
    Given I am not logged in
    And the project has not happened yet
    When I go to the project page
    Then I should be on the groups projects page
