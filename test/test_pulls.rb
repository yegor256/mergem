# Copyright (c) 2022 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require 'octokit'
require 'loog'
require_relative '../lib/mergem/pulls'

# Test for Pulls.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022 Yegor Bugayenko
# License:: MIT
class TestPulls < Minitest::Test
  def test_real
    api = Octokit::Client.new
    m = Mergem::Pulls.new(api, Loog::VERBOSE, ['yegor256/blog', 'polystat/*'])
    ms = []
    total = m.each do |repo, pr|
      ms << "#{repo}##{pr}"
    end
    assert(!ms.empty?)
    assert_equal(total, ms.count)
    p ms
  rescue Octokit::TooManyRequests => e
    puts e.message
    skip
  end

  def test_ignore_archived
    api = Octokit::Client.new
    m = Mergem::Pulls.new(api, Loog::VERBOSE, ['yegor256/netbout'])
    assert_equal(0, m.each)
  rescue Octokit::TooManyRequests => e
    puts e.message
    skip
  end
end
