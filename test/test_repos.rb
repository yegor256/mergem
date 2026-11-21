# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'loog'
require 'minitest/autorun'
require 'octokit'
require_relative '../lib/mergem/repos'

# Test for Repos.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class TestRepos < Minitest::Test
  def test_deduplicates_overlapping_masks
    repos = Mergem::Repos.new(
      Class.new do
        define_method(:repositories) do |_org|
          [{ 'full_name' => 'foo/bar' }, { 'full_name' => 'foo/baz' }]
        end
        define_method(:repository) do |_name|
          { archived: false }
        end
      end.new,
      Loog::NULL, ['foo/*', 'foo/bar', 'foo/*', 'foo/bar']
    )
    names = []
    assert_equal(2, repos.each { |name| names << name })
    assert_equal(['foo/bar', 'foo/baz'], names.sort)
  end

  def test_finds_repositories_from_multiple_sources
    r = Mergem::Repos.new(Octokit::Client.new, Loog::VERBOSE, ['yegor256/blog', 'polystat/*'])
    ms = []
    assert_equal(r.each { |repo| ms << repo }, ms.count)
    refute_empty(ms)
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('It is OK')
  end

  def test_skips_excluded_repository_offline
    assert_equal(
      0,
      Mergem::Repos.new(
        Class.new do
          def repository(name)
            raise(StandardError, "Repository #{name} was fetched")
          end
        end.new,
        Loog::NULL, ['foo/bar'], ['foo/bar']
      ).each,
      'Excluded repository was not skipped'
    )
  end

  def test_ignores_archived_repositories
    assert_equal(0, Mergem::Repos.new(Octokit::Client.new, Loog::VERBOSE, ['polystat/j2ast']).each)
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('It is OK')
  end
end
