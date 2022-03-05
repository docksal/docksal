# Contributing to Docksal

Thanks for your interest in contributing to Docksal!

There are many ways you can help the project:

- [Report issues](#report-issues)
- [Contribute code](#contribute-code)
- [Provide community support](#provide-community-support)


## Report issues

First search the [issue queue](https://github.com/docksal/docksal/issues). 
Others may have experienced the same or a similar issue and have already found a solution or a workaround.

File a new issue if your problem looks to be brand new.

When reporting a functionality related issue, please provide diagnostics information from `fin sysinfo`.
We aim to provide cross-platform support and need to know what's under the hood in your particular case.

Listing detailed steps to reproduce an issue will also help us understand the problem better and fix it faster.   


## Contribute code

We are sticking with [GitHub Flow](https://guides.github.com/introduction/flow/) as our git workflow.

- `develop` - development branch, all PRs should be submitted against it
- `master` - main stable branch, matches the latest release at all times
- `feature/feature-name` - isolated/experimental feature development happens here

To contribute to the project:

- Fork the repo
- Create a feature branch (optional)
- Commit code with meaningful commit messages
- Create a pull request against `develop`
- Discuss the PR with the [maintainers](MAINTAINERS.md), update it as necessary
- Once approved the PR will be merged

Each PR goes through automated tests on [Travis CI](https://travis-ci.org/docksal/docksal/pull_requests).
If your PR does not pass the tests, you either have to fix the code or fix the test.


## Provide community support

We have chat rooms on Gitter and Slack where questions can be asked and answered: 

- [Discussions](https://github.com/docksal/docksal/discussions) on GitHub
- [Drupal Slack](https://app.slack.com/client/T06GX3JTS/C6GPEEEV8)

If you have experience with Docksal and Docker, please stick around in the rooms to help others.
