# Changelog

## 0.12.0 (2015-04-07)

- Added "browser" node for Behat tests requiring JS support
- Documented using Behat
- CI: circle.docker-compose.yml us now used for automated tests of Drude, while docker-compose.yml is still the one packaged for distribution. This is not ideal... Need to figure out a way to alter docker-compose.yml during the build to comment out sections used in Drude's own CI tests, but optional for end users.

## 0.11.0 (2015-03-27)

- Drude Shell (dsh) tool - an all-in-one tool for daily Drude use
- New build and release process
- Using semantic versioning and tracking changes in the CHANGELOG.md file
- CircleCI integration for automated testing and build purposes
- New install and update process
- Documentation overhaul
