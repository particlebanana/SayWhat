@groups
Feature: Setup a group

  Background: 
    Given I am not logged in

  Scenario: I use the generated link in my email to login and create a new password
    When I follow the link that was emailed to me
    Then I should be logged in
    And I fill in "testpassword" within create a new password field
    And I press next
    Then I should have a new password
    