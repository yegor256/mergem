# Copyright (c) 2022-2025 Yegor Bugayenko
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

# Find all repositories by the locations provided.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2022-2025 Yegor Bugayenko
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
    names.each do |n|
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
