# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Ask Rultor to merge a pull request.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class Mergem::AskRultor
  def initialize(api, loog)
    @api = api
    @loog = loog
    @bots = ['renovate[bot]', 'dependabot[bot]', 'dependabot-preview[bot]']
  end

  def ask(repo, num)
    begin
      user = @api.user[:login]
    rescue Octokit::Unauthorized
      user = 'yegor256'
      @loog.debug('You are not using GitHub token :( Try to use --token option.')
    end
    issue = @api.issue(repo, num)
    title = "#{repo}##{num}"
    author = issue[:user][:login]
    unless @bots.include?(author)
      @loog.debug("#{title} is authored by @#{author} (not a bot)")
      return true
    end
    json = @api.issue_comments(repo, num)
    @loog.debug("Found #{json.count} comments in #{title}")
    unless json.find { |j| j[:user][:login] == user }.nil?
      @loog.debug("#{title} was already discussed by @#{user}")
      return true
    end
    sha = @api.pull_request(repo, num)[:head][:sha]
    checks = @api.check_runs_for_ref(repo, sha)[:check_runs]
    checks.each do |check|
      if check[:status] != 'completed'
        @loog.debug("Check #{check[:id]} at #{title} is still running, let's try to merge later")
        return false
      end
      if check[:conclusion] != 'success'
        @loog.debug("Check #{check[:id]} at #{title} failed, no reason to try to merge")
        return true
      end
      @loog.debug("Check #{check[:id]} at #{title} is '#{check[:status]}/#{check[:conclusion]}', good!")
    end
    @loog.debug("All #{checks.count} check(s) completed successfully in #{title}")
    msg = '@rultor please, try to merge'
    msg += ", since #{checks.count} checks have passed" if checks.any?
    @api.add_comment(repo, num, msg)
    @loog.info("Comment added to #{title}")
    true
  end
end
