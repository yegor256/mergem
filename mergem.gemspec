# SPDX-FileCopyrightText: Copyright (c) 2022-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'English'

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/mergem/version'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>= 2.2'
  s.name = 'mergem'
  s.version = Mergem::VERSION
  s.license = 'MIT'
  s.metadata = { 'rubygems_mfa_required' => 'true' }
  s.summary = 'GitHub API client that deals with Pull Requests'
  s.description = 'tbd...'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'https://github.com/yegor256/mergem'
  s.files = `git ls-files | grep -v -E '^(test/|\\.|renovate)'`.split($RS)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md', 'LICENSE.txt']
  s.add_dependency 'backtrace', '~>0.3'
  s.add_dependency 'iri', '~>0.5'
  s.add_dependency 'loog', '~>0.2'
  s.add_dependency 'nokogiri', '~>1.18'
  s.add_dependency 'obk', '~>0.3'
  s.add_dependency 'octokit', '~>10.0'
  s.add_dependency 'rainbow', '~>3.0'
  s.add_dependency 'slop', '~>4.4'
  s.add_dependency 'tacky', '~>0.3'
end
