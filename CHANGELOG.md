# Changelog

## 1.4.0 (2016-06-10)

- dsh v1.20.0
- Added update checker (once a week, currently dsh only)
- Allow install prerequisites on other Linux versions if user takes the risk
- dsh -v will now show short version
- New command `dsh system-info` for debugging purposes
- System-wide services
  - New service: `ssh-agent`. See [ssh-agent docs](docs/ssh-agent.md) for more details.
  - Bind system-wide services to 0.0.0.0 for simplicity
  - `dsh reset` can now install/reset system-wide services (dns, vhost-proxy, ssh-agent)
- Support for [custom commands](docs/custom-commands.md) in dsh
- Support for overlay networks for vhost-proxy (v2 compose file format)
- Other improvements
  - dsh remove -f to quietly remove containers
  - Support dsh reset -f to quietly reset containers
- Documentation updates
 - [Docs](docs/apache-solr.md) for Apache Solr
 - [Docs](docs/settings.md) on switching PHP and MySQL versions
- Many other small updates and fixes 


## 1.3.4 (2016-05-04)

- dsh v1.13.3
  - Fix regression with is_docker_running check in boot2docker

A full update is recommended. Please follow the updates instructions:
https://github.com/blinkreaction/drude#updates


## 1.3.3 (2016-04-29)

- dsh v1.13.2
  - Fix regression with dsh behat

A full update is recommended. Please follow the updates instructions:
https://github.com/blinkreaction/drude#updates


## 1.3.2 (2016-04-26)

- dsh v1.13.1
  - Fix regression with docker-compose related function calls introduced in dsh v1.13.0
- Documentation fixes

A full update is recommended. Please follow the updates instructions:
https://github.com/blinkreaction/drude#updates


## 1.3.1 (2016-04-21)

- A lot of refactoring to bring interactive shell experience to Windows (via winpty, which is a requirement now on Windows)
  - `dsh update boot2docker` will now ask for a confirmation
  - `dsh exec` (`dsh run`) can now run interactive commands (try `dsh exec top`)
  - `dsh bash` now longer relies on `vagrant ssh -c` and thus launches much faster
  - `dsh mysql-import` now disaplays a progress via `pv` (same as on Mac/Linux)
- Fixed `dsh bash`regression from v1.3.0 on Mac/Linux
- Documentation fixes and updates

A full update is recommended. Please follow the updates instructions:
https://github.com/blinkreaction/drude#updates


## 1.3.0 (2016-04-15)

- Implement dsh drupal shortcut for Drupal Console commands
- dsh bash improved on Windows
  - Use winpty on Windows (if installed), fall back to "vagrant ssh" otherwise
- Make sure Docker TLS is disabled
- Refactored of install/update commands
- Refactored of docker daemon status check on different platforms
- Automatic detection of host user id
  - Docker user id in cli is matched to the host user id
  - Add messaging that running as root is not recommended
- Fixed the issue with line breaks when running dsh stop
- Fixed dsh drush (with no arguments) throws an error message
- Documentation updates
 - Added MailHog service usage instructions
 - Added Varnish service usage instructions
 - Misc update and typo fixes


## 1.2.4 (2016-01-20)

- Bump dsh to v1.10.3
  - Fixed "tput: No value for $TERM and no -T specified" in noninteractive (CI) environments
  - Fixed "Error response from daemon: no such id: bash" on Windows
- Restructured and updated docs with setup instructions per use case

## 1.2.3 (2015-12-04)

- Bump dsh to v1.9.3
  - Fix in _set_cli_uid for non-interactive sessions

## 1.2.2 (2015-12-04)

- Fix a really tiny typo in the README.
- Bump dsh to v1.9.2
  - Fix DRUDE_SET_UID usage (experimental) when combined with DRUDE_DC_PROJECT.

## 1.2.1 (2015-11-17)

- Droped /cygdrive prefix on Windows
  - Compatibility fix for the new docker-compose binary on Windows in boot2docker-vagrant v1.3.0+
- Fixed Ubuntu version check
- Updated minimal versions requirements

## 1.2.0 (2015-11-11)

- Ubuntu support
  - Added docker-compose installation
  - Point dns service to 8.8.8.8 to prevent it from recursing to itself
- Allow to override the user id in the cli container via DRUDE_SET_UID environment variable
  - Experimental. Requires `blinkreaction/drupal-cli:latest`
- Fixed #65 (`dsh stop --all` should not stop system containers)
- Docs updates
 - MySQL DB access for external tools
 - Updated minimal versions requirements

## 1.1.0 (2015-10-26)

Notable changes:

- Lots of dsh updates
  - `dsh remove` can now remove a single container
  - `dsh stop --all` will stop all running containers
  - `dsh restart` command now restarts only containers
  - `dsh reset` can reset individual container
  - `dsh logs` command will display all/individual container logs
  - `dsh vmstat` command will show VirtualBox VM stats
  - `dsh exec-url` command will download a script from a URL and run it
  - `dsh behat` now access a `--path=<path-to-behat>` option
  - `dsh install prerequisites` now supports Ubuntu 14.04+
- docker-compose.yml
  - BIG CHANGE: PHP is now solely in the CLI container (single place for cli and web). Web container has Apache only and uses php-fpm service in CLI.
  - Added Solr container example
  - DOMAIN_NAME environment variable can now be used for service discovery between containers (instead of docker links). Using this will memcached, browser and solr nodes.
  - Using stable tags for web (blinkreaction/drupal-apache:2.2-stable) and cli (blinkreaction/drupal-cli:stable)
- Documentation updates
  - Updated docs on D7 and D8 settings (including reverse proxy settings for vhost-proxy)
  - Updated Behat instructions
  - Added Drupal 8 sample project link
- Miscellaneous
  - Removed CircleCI stuff. It has not been used in a while and is outdated
  - Changed default docker host to 192.168.10.10:2375 (private network interface) instead of 127.0.0.1:2375 (NAT) for better performance of the docker client with VBox's Intel adapters
  - Added error reporting php settings in [examples/.drude/etc/php5](examples/.drude/etc/php5)

## 1.0.1 (2015-09-14)

- Bump dsh version to v1.0.1

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
