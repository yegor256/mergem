# Auto-Ask Rultor to Merge Pull Requests from Robots

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](https://www.rultor.com/b/yegor256/mergem)](https://www.rultor.com/p/yegor256/mergem)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/mergem/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/mergem/actions/workflows/rake.yml)
[![Gem Version](https://badge.fury.io/rb/mergem.svg)](https://badge.fury.io/rb/mergem)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/mergem/blob/master/LICENSE.txt)
[![Test Coverage](https://img.shields.io/codecov/c/github/yegor256/mergem.svg)](https://codecov.io/github/yegor256/mergem?branch=master)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/mergem)](https://hitsofcode.com/view/github/yegor256/mergem)

This simple script may help you deal with pull requests
coming to your GitHub repositories from robots:

```bash
gem install mergem
```

Then, run it locally and read its output:

```bash
mergem --repo yegor256/mergem --verbose --token <YOUR_GITHUB_TOKEN>
```

First, it will find all pull requests in `yegor256/mergem` GitHub repository,
which were not yet discussed by the owner of the token. Then, it will ignore
those pull requests that are coming not
from [Renovate](https://github.com/apps/renovate)
or [Dependabot](https://github.com/dependabot). Then, it will
post `@rultor merge` text message to each pull request left in the list.

## Token

`mergem` requires a GitHub token to be passed via the `--token` option.
To obtain one, go to your GitHub account, then navigate to "Settings," and then
to ["Developer Settings"](https://github.com/settings/tokens).

### Classic Token

You can create a classic token with the `public_repo` ("Access public
repositories") scope. It will grant `mergem` all the necessary permissions to
read and write comments on repositories.

### Fine-grained Token

Another option is to create a fine-grained token with "All Repositories" access.
In this case, you will need to assign the following permissions to the token:

* Issues, "Read and write"
* Pull requests, "Read and write"
* Contents, "Read and write"

Please note that fine-grained tokens might encounter issues with repositories
not owned by you or owned by an organization. In such cases, you may need to
obtain additional approval from the organization.

> During the beta, organizations must opt in to fine-grained personal access
> tokens. If your organization has not already opted-in, then you will be
> prompted
> to opt-in and set policies when you follow the steps below.

Read about [setting a personal access][PAT] token policy for your organization.

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute your pull request. You will
need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+
and [Bundler](https://bundler.io/) installed. Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.

In order to run a single test:

```bash
bundle exec ruby test/test_askrultor.rb
```

[PAT]: https://docs.github.com/en/organizations/managing-programmatic-access-to-your-organization/setting-a-personal-access-token-policy-for-your-organization
