@admin
Feature: Site Admin approves the creation of a group

  Background: 
    Given I am a Site Admin
    And I am logged in
    And there is a pending group named "Han Shot First"

  Scenario: I approve the creation of a group
    When I go to the requests page
    Then I should see "Han Shot First"
    And I follow "Han Shot First"
    Then I should see "Sponsor Name: Han Solo"
    And I should see "Sponsor Email: user007@gmail.com"
    And I press "Approve"
    Then the group should be approved
    And The "adult sponsor" should receive an email at "user007@gmail.com" with the subject "Your group has been approved on SayWhat!"