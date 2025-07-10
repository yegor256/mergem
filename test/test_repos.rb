# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require 'loog'
require_relative '../lib/mergem/repos'

# Test for Repos.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class TestRepos < Minitest::Test
  def test_finds_repositories_from_multiple_sources
    api = Octokit::Client.new
    r = Mergem::Repos.new(api, Loog::VERBOSE, ['yegor256/blog', 'polystat/*'])
    ms = []
    total = r.each do |repo|
      ms << repo
    end
    refute_empty(ms)
    assert_equal(total, ms.count)
  rescue Octokit::TooManyRequests => e
    puts e.message
    skip('It is OK')
  end

  def test_ignores_archived_repositories
    api = Octokit::Client.new
    r = Mergem::Repos.new(api, Loog::VERBOSE, ['polystat/j2ast'])
    assert_equal(0, r.each)
  rescue Octokit::TooManyRequests => e
    puts e.message
    skip('It is OK')
  end
end
