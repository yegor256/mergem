Feature: Simple Reporting
  I want to be able to build a report

  Scenario: Help can be printed
    When I run bin/mergem with "-h"
    Then Exit code is zero
    And Stdout contains "--help"

  Scenario: Version can be printed
    When I run bin/mergem with "--version"
    Then Exit code is zero

  Scenario: Simple roundtrip to GitHub
    When I run bin/mergem with "--repo yegor256/mergem --dry --token foo"
    Then Stdout contains "Repo yegor256/mergem checked"
    And Exit code is zero
