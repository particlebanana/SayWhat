@group
Feature: Invite a member to join a group

  Background: 
    Given I am logged in as "han.solo@gmail.com"

  Scenario: I invite a member
    When I go to the invite member page
    And I fill in the following:
      | user_email         | invite_member@gmail.com  |
    When I press "Send Invite"
    Then The "invitee" should receive an email at "invite_member@gmail.com" with the subject "You have been invited to join Evil Empire on SayWhat!"