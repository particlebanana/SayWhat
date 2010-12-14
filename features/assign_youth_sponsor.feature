@group
Feature: Assign a Youth Sponsor to a group

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And I am an "adult sponsor"
    And there is a "member" with the email "luke.skywalker@gmail.com"
    
  Scenario: I want to choose a current group member to be a group sponsor
    Given I am on my group page
    Then I should see "edit"
    And I follow "edit"
    Then I should see "Group Sponsors"
    And I should see "Assign a youth sponsor"
    And I follow "Assign a youth sponsor"
    Then I should see "Luke Skywalker"
    And I follow "assign"
    Then I should see "Luke Skywalker" within the youth sponsor
    And The "sponsor" should receive an email at "luke.skywalker@gmail.com" with the subject "You have been promoted to a sponsor for the group Evil Empire on SayWhat!"