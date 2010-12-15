@project
Feature: Report on a project

  Background: 
    Given I am logged in as "han.solo@gmail.com"
    And I am an "adult sponsor"
    And there is a project named "Build The Death Star"
    And the project has already happened

  Scenario: I want to report on a project
    Given I am on the project page
    Then I should see "Report on this project"
    And I follow "Report on this project"
    And I fill in the following:
      | report_number_of_youth_reached       | 10                                          |
      | report_number_of_adults_reached      | 20                                          |
      | report_percent_male                  | 50                                          |
      | report_percent_female                | 50                                          |
      | report_percent_african_american      | 5                                           |
      | report_percent_asian                 | 5                                           |
      | report_percent_caucasian             | 5                                           |
      | report_percent_hispanic              | 5                                           |
      | report_percent_other                 | 80                                          |
      | report_comment                       | This was a success! We can blow up planets! |
    And I select "$100+" from "report_money_spent"
    And I select "1 month+" from "report_prep_time"
    And I press "Submit Report"
    Then I should see "Report Successfully Submitted"