# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'loog'
require 'minitest/autorun'
require 'octokit'
require_relative '../lib/mergem/askrultor'

# Test for AskRultor.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class TestAskRultor < Minitest::Test
  def test_retries_after_failed_checks_pass
    actions = []
    conclusions = %w[failure success]
    api = Object.new
    {
      user: { login: 'merger' },
      issue: { user: { login: 'dependabot[bot]' } },
      issue_comments: [],
      pull_request: { head: { sha: 'head' } }
    }.each do |method, result|
      api.define_singleton_method(method) { |*_args| result }
    end
    api.define_singleton_method(:check_runs_for_ref) do |*_args|
      { check_runs: [{ id: 1, status: 'completed', conclusion: conclusions.shift }] }
    end
    %i[create_pull_request_review add_comment].each do |method|
      api.define_singleton_method(method) { |*args| actions << args }
    end
    merger = Mergem::AskRultor.new(api, Loog::NULL)
    refute(merger.ask('foo/bar', 42))
    assert_empty(actions)
    assert(merger.ask('foo/bar', 42))
    assert_equal(
      [
        ['foo/bar', 42, { event: 'APPROVE' }],
        ['foo/bar', 42, '@rultor please, try to merge, since 1 checks have passed']
      ],
      actions
    )
  end

  def test_asks_rultor_to_merge_pull_request
    assert(Mergem::AskRultor.new(Octokit::Client.new, Loog::VERBOSE).ask('yegor256/mergem', 1))
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('It is OK')
  end
end
