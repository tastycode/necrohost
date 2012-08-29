Feature: User wants the server to be sleepy

  Scenario: User requests normal sleep
    Given the application is configured to bypass sleeping
    And I go to the url for sleeping for 5 seconds
    Then the result should mention how much I slept
