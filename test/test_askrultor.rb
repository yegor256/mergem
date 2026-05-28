require 'loog'
# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require_relative '../lib/mergem/askrultor'

# Test for AskRultor.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class TestAskRultor < Minitest::Test
  def test_asks_rultor_to_merge_pull_request
    assert(Mergem::AskRultor.new(Octokit::Client.new, Loog::VERBOSE).ask('yegor256/mergem', 1))
  rescue Octokit::TooManyRequests => e
    puts(e.message)
    skip('It is OK')
  end
end
