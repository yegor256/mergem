require 'loog'
# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require_relative '../lib/mergem/pulls'

# Test for Pulls.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class TestPulls < Minitest::Test
  def test_fetches_pull_requests_from_repository
    m = Mergem::Pulls.new(Octokit::Client.new, Loog::VERBOSE, 'yegor256/blog')
    ms = []
    assert_equal(m.each { |pr| ms << "##{pr}" }, ms.count)
    refute_empty(ms)
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('It is OK')
  end
end
