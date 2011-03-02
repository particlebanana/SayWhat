@group
@approve
Feature: Site Admin approves the creation of a group

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a pending group named "Han Shot First"

  Scenario: I approve the creation of a group
    When I go to the pending groups page
    Then I should see "Han Shot First"
    And I follow "Han Shot First"
    And I press "Approve Group"
    Then the group should be approved
    And The "adult sponsor" should receive an email at "han.solo@gmail.com" with the subject "Your group has been approved on SayWhat!"