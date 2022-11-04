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

# Ask Rultor to merge a pull request.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022 Yegor Bugayenko
# License:: MIT
class Mergem::AskRultor
  def initialize(api, loog)
    @api = api
    @loog = loog
    @bots = ['renovate[bot]', 'dependabot[bot]']
  end

  def ask(repo, num)
    begin
      user = @api.user[:login]
    rescue Octokit::Unauthorized
      user = 'yegor256'
      @loog.debug('You are not using GitHub token...')
    end
    issue = @api.issue(repo, num)
    title = "#{repo}##{num}"
    author = issue[:user][:login]
    unless @bots.include?(author)
      @loog.debug("#{title} is authored by @#{author} (not a bot)")
      return false
    end
    json = @api.issue_comments(repo, num)
    @loog.debug("Found #{json.count} comments in #{title}")
    unless json.find { |j| j[:user][:login] == user }.nil?
      @loog.debug("#{title} was already discussed by @#{user}")
      return false
    end
    @api.add_comment(repo, num, '@rultor please, try to merge')
    @loog.info("Comment added to #{title}")
    true
  end
end
