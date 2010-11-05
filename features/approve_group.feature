@groups
Feature: Site Admin approves the creation of a group

  Background: 
    Given I am logged in
    And I am a 'Site Admin'
    And there is a pending group named "Billy Bob's Kids"

  Scenario: I approve the creation of a group
    When I go to the pending groups page
    Then I should see "Billy Bob's Kids" within the pending groups list
    When I click "Billy Bob's Kids" within the pending groups list
    Then I press "Approve Group"
    Then the group should be approved