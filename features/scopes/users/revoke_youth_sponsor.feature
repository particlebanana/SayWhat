@group
Feature: Revoke a Youth Sponsor from a group

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And I am an "adult sponsor"
    And there is a "youth sponsor" with the email "luke.skywalker@gmail.com"
    
  Scenario: I want to revoke Youth Sponsorship privileges from a member
    Given I am on my group page
    Then I should see "edit"
    And I follow "edit"
    Then I should see "Group Sponsors"
    And I should see "Luke Skywalker" within the youth sponsor
    And I follow "revoke"
    Then I should see "Assign a youth sponsor"
    And The "member" should receive an email at "luke.skywalker@gmail.com" with the subject "You have been demoted from sponsor for the group Evil Empire on SayWhat!"