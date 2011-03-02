@group
@messages
Feature: Group Sponsor approves pending membership request

  Background: 
    Given there is a group named "Han Shot First"
    And I am logged in
    And I am an 'Adult Sponsor'
    And there is a pending member

  Scenario: I approve a pending membership
    When I go to my messages page
    Then I should see "New Membership Request"
    And I follow "New Membership Request"
    Then I should see "Approve Member"
    And I should see "Deny Member"
    When I follow "Approve Member"
    Then I should see "Member has been added"
    And the member should be approved
    And The "member" should receive an email at "billy.bob.jo@gmail.com" with the subject "You have been approved for membership on SayWhat!"