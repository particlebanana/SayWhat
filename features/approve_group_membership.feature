@group
Feature: Group Sponsor approves pending membership request

  Background: 
    Given there is a group named "Han Shot First"
    And I am logged in
    And I am an 'Adult Sponsor'
    And there is a pending member

  Scenario: I approve a pending membership
    When I go to the pending members page
    Then I should see "Han Solo" within the pending members list
    Then I click "approve" within the pending members list
    Then I should see "No Pending Members"
    And the member should be approved
    And The "member" should receive an email at "billy.bob.jo@gmail.com" with the subject "You have been approved for membership on SayWhat!"