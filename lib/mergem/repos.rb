# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Find all repositories by the locations provided.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2026 Yegor Bugayenko
# License:: MIT
class Mergem::Repos
  def initialize(api, loog, masks)
    @api = api
    @loog = loog
    @masks = masks
  end

  def each
    total = 0
    names = []
    @masks.each do |repo|
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
    names.shuffle.each do |n|
      r = @api.repository(n)
      if r[:archived]
        @loog.debug("Repository #{n} is archived, ignoring")
        next
      end
      yield n
      total += 1
    end
    total
  end
end
