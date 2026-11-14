# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'

# Tests for the command-line cache round trip.
class TestCli < Minitest::Test
  GITHUB = <<-RUBY.freeze
    require 'base64'
    require 'octokit'

    class Octokit::Client
      def contents(*)
        { content: Base64.encode64(File.read('remote')), sha: 'cache-sha' }
      end

      def repository(*)
        { archived: false }
      end

      def pull_requests(*)
        [{ number: 42 }]
      end

      def issue(*)
        raise 'An already cached pull request was fetched again'
      end

      def update_contents(_repo, _path, _message, _sha, content, _options = {})
        File.write('remote', content)
      end
    end

    load ARGV.shift
  RUBY

  def test_preserves_decoded_github_cache_across_runs
    cli = File.expand_path('../bin/mergem', __dir__)
    Dir.mktmpdir('mergem-cache', __dir__) do |dir|
      remote = File.join(dir, 'remote')
      cache = File.join(dir, 'local')
      titles = (42..47).map { |n| "foo/bar##{n}" }.join("\n")
      File.write(remote, titles)
      2.times do
        stdout, stderr, status = Open3.capture3(
          { 'HOME' => dir }, RbConfig.ruby, '-e', GITHUB, cli,
          '--repo', 'foo/bar', '--cache', cache,
          '--github-cache', 'foo/bar/cache/latest.txt', '--delay', '0', '--verbose', chdir: dir
        )
        assert_predicate(status, :success?, "#{stdout}\n#{stderr}")
        assert_includes(stdout, "'foo/bar#42' is already in cache, skipping it")
        assert_equal(titles, File.read(cache))
        assert_equal(titles, File.read(remote))
      end
    end
  end
end
