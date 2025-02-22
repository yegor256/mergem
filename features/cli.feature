# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT
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
    When I run bin/mergem with "--repo yegor256/mergem --dry --verbose"
    Then Stdout contains "1 PRs processed"
    And Exit code is zero

  Scenario: Skip all repos
    When I run bin/mergem with "--repo yegor256/mergem --exclude yegor256/mergem --verbose"
    Then Stdout contains "skipped"
    And Exit code is zero
