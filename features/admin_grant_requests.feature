@admin
@grant
Feature: Site Admin views the pending and approved grant applications

  Background: 
    Given I am a Site Admin
    And I am logged in

  Scenario: I view the list of active grant applications
    Given there is an active grant application for "Rebel Alliance"
    When I go to the grants page
    Then I should see "Active Mini-Grant Applications"
    And I should see "Rebel Alliance"
    And I should see "Han Solo"
    And I should see "han.solo@gmail.com"
    
  Scenario: There are not active grants
    Given there are no active grant applications
    When I go to the grants page
    Then I should see "No active grant applications."
    
  Scenario: I view the list of pending grant applications
    Given there is a pending grant application for "Trade Federation"
    When I go to the pending grants page
    Then I should see "Pending Mini-Grant Applications"
    And I should see "Trade Federation"
    And I should see "Han Solo"
    And I should see "han.solo@gmail.com"
    
  Scenario: There are not pending grant applications
    Given there are no pending grant applications
    When I go to the pending grants page
    Then I should see "No pending grant applications."
