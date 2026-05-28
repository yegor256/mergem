require 'loog'
# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require_relative '../lib/mergem/repos'

# Test for Repos.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class TestRepos < Minitest::Test
  def test_finds_repositories_from_multiple_sources
    r = Mergem::Repos.new(Octokit::Client.new, Loog::VERBOSE, ['yegor256/blog', 'polystat/*'])
    ms = []
    assert_equal(r.each { |repo| ms << repo }, ms.count)
    refute_empty(ms)
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('It is OK')
  end

  def test_ignores_archived_repositories
    assert_equal(0, Mergem::Repos.new(Octokit::Client.new, Loog::VERBOSE, ['polystat/j2ast']).each)
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('It is OK')
  end
end
