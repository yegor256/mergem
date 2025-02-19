# SPDX-FileCopyrightText: Copyright (c) 2022-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Pulls in GitHub API.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
# License:: MIT
class Mergem::Pulls
  def initialize(api, loog, repo)
    @api = api
    @loog = loog
    @repo = repo
  end

  def each
    json = @api.pull_requests(@repo, state: 'open')
    @loog.debug("Found #{json.count} pull requests in #{@repo}")
    total = 0
    json.each do |p|
      yield p[:number]
      total += 1
    end
    total
  end
end
