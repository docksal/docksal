# Changelog

## 1.0.0 (2015-09-14)

- Properly handle complex parameters in `dsh drush`
- Bash autocomplete for dsh
- Support running drush with symlinked directories
- Host's home directory mapping in CLI container to simplify mounts for SSH keys and other credentials and configs.
- Support for custom SSH key names
- Debugging with Xdebug tutorial
- Documentation cleanup and updates (php and mysql settings overrides, vhost-proxy usage, troubleshooting docs)

## 1.0.0-rc1 (2015-08-26)

- Switching shell scripts back to /bin/bash for consistency across all platforms
- Added support for `dsh bash <service name>`
- Support for import of gzipped DB dumps in `dsh mysql-import` command
- `dsh reset` now removes container volumes
- Mount both .ssh folder options (Linux and B2D) for `cli`
- Complete overhaul of the install/update process
  - `dsh install prerequisites`, `dsh install boot2docker`, `dsh install drude` commands for Mac and Windows
  - Use **Babun Shell** instead of **Git Bash** on Windows
  - Get rid of the dsh wrapper script - install dsh directly
  - Abandon git based install method. Remove git repository requirement
  - Repo structure overhaul. Only `docker-compose.yml` is installed into a project repo
  - `dsh update`: make sure `~/.drude exists`, otherwise config backups will fail
  - Removed obsolete scripts
  - Added `dsh version` and `dsh self-update` commands
- Added `dsh init` command (calls .drude/scripts/drude-init.sh)
  - Added `.drude/scripts/example.drude-init.sh` script
  - `dsh init` can accept a URL argument for the `drude-init.sh` script
- `dsh drush` functions now works even outside of the docroot
- Proper handling of non-interactive shells
- Switching to php5.6 for both `web` and `cli`
- Switching containers to non-conflicting port mode - using vhost-proxy
- Instructions for configuring *.drude wildcard DNS resolution on Mac
- Use a helper function to call docker-compose and pass file and project arguments
- Support for defining a Drude and boot2docker-vagrant branch for testing purposes via environment variables (`DRUDE_BRANCH`, `B2D_BRANCH`)
- Refactor `_run` command. cmdpath is not needed anymore
- Fix cli php config path
- Automatically configure `DOCKER_HOST` on Mac and Windows (on every dsh call), skip on Linux
- Workaround for `dsh bash` on Windows via `vagrant ssh -c`
- Hidden (dev-only) `dsh remove` command
- Mac only: desktop notification when mysql import has finished
- Other miscellaneous fixes and improvements
- Documentation updates

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
