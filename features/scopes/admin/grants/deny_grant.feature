@admin
@grant
Feature: Site Admin approves a Mini-Grant Application

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a pending grant application for "Trade Federation"
  
  @javascript
  Scenario: I deny the grant application
    When I go to the pending grants page
    Then I should see "Trade Federation"
    And I follow "Trade Federation"
    Then I should see "Group Name: Trade Federation"
    And I should see "Status: Pending"
    And I follow "Deny"
    Then I should see "Are you sure you want to deny this grant application?"
    And I select "Incorrect curriculum" from "deniedReasons"
    And I follow "Deny Grant"
    Then the grant application should be denied
    And The "adult sponsor" should receive an email at "han.solo@gmail.com" with the subject "SayWhat! Mini-Grant Has Been Denied"