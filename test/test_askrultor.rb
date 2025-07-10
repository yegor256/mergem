# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'octokit'
require 'loog'
require_relative '../lib/mergem/askrultor'

# Test for AskRultor.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class TestAskRultor < Minitest::Test
  def test_asks_rultor_to_merge_pull_request
    api = Octokit::Client.new
    m = Mergem::AskRultor.new(api, Loog::VERBOSE)
    asked = m.ask('yegor256/mergem', 1)
    assert(asked)
  rescue Octokit::TooManyRequests => e
    puts e.message
    skip('It is OK')
  end
end
