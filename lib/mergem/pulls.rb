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

# Pulls in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022 Yegor Bugayenko
# License:: MIT
class Mergem::Pulls
  def initialize(api, loog, repos)
    @api = api
    @loog = loog
    @repos = repos
  end

  def each
    total = 0
    names = []
    @repos.each do |repo|
      if repo.end_with?('/*')
        org = repo.split('/')[0]
        @api.repositories(org).each do |r|
          n = r['full_name']
          @loog.debug("Found #{n} repo in @#{org}")
          names << n
        end
      else
        names << repo
      end
    end
    names.each do |repo|
      json = @api.pull_requests(repo, state: 'open')
      @loog.debug("Found #{json.count} pull requests in #{repo}")
      json.each do |p|
        yield repo, p[:number]
        total += 1
      end
    end
    total
  end
end
