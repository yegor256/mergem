# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require 'loog'
require_relative '../lib/mergem/pulls'

# Test for Pulls.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class TestPulls < Minitest::Test
  def test_fetches_pull_requests_from_repository
    api = Octokit::Client.new
    m = Mergem::Pulls.new(api, Loog::VERBOSE, 'yegor256/blog')
    ms = []
    total = m.each do |pr|
      ms << "##{pr}"
    end
    refute_empty(ms)
    assert_equal(total, ms.count)
  rescue Octokit::TooManyRequests => e
    puts e.message
    skip('It is OK')
  end
end
