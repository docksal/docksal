# Changelog

# 1.3.1 (2017-06-02)

## New software versions 
* **fin 1.10.0**

## Fixes and improvements

* Fix retrospective bug that was making `DOCKSAL_DNS2` value empty
* Fix permissions issues on Windows that were related to improper `uid`/`gid`
* Fix edge case with software versions comparison, that prevented software installations in some cases (#224)
* Refactored automatic DNS resolver configuration
  - Doing a DNS probe to make sure the upstream DNS server is reachable
  - Using `8.8.8.8` a the default upstream DNS on all platforms
  - `DOCKSAL_DNS_UPSTREAM` can be used to override the default upstream DNS server
  - Automatic DNS resolver can now be disabled via `DOCKSAL_NO_DNS_RESOLVER=true`
  - Set interface metric on Windows. This makes sure our VBox adapters is the first in the list and thus it's DNS server settings will be used by Windows
  - Adding configure_resolver "off" mode. This will revert resolver settings when the VM is stopped, killed, removed
  - Added a flag to control query logging in `docksal-dns`
  - Updated docs regarding the DNS resolver


# 1.3.0 (2017-05-16)

## New Features

* `*.docksal` domain resolver now works on Windows removing the need to edit the `hosts` file! 
* `fin db <command>` replaces all previously existing mysql related commands (`sqli` is now `db import` etc.). See `fin db help` for details. Old commands still work for compatibility.
* `fin vm hdd` - show VM hdd capacity and usage. `fin vm stats` will only show CPU and network stats now
* `fin hosts` - easily add or remove a host to/from OS-dependent `hosts` file (Relates to #113)
* Override VirtualBox HDD size during VM creation. Set `VBOX_HDD` environment variable to the desired size in megabytes. Default is `50000`. (see https://github.com/docksal/docksal/commit/d50e00367514f64ad0ae4421f6d08cc614d39e2e for details)

## Changes and improvements

* Windows SMB share creation and mount refactoring
    - Prefix Docksal SMB shares with `docksal-` to avoid conflicts with existing shares. Docksal share names on Windows will now look like `\\computer\docksal-c` instead of `\\computer\c` before. Should address file permissions issues some Windows users had had.
    - Domain name is now properly passed during shares mount. Should address share mount issues for domain users.
    - Mount SMB shares with `ntlmssp` or `ntlm` security options. Perform two attempts: use `ntlmssp` by default, use `ntlm` as a fallback. Should address issues for many users of corporate Windows laptops (#117)
    - Perform umount before mount in `smb_share_mount` to simplify debugging (e.g. `fin vm mount` to remount the share)
    - Allow overriding CIFS `sec` option by setting `SEC_SMB` environment variable. Useful for debugging or for edge cases when neither of existing options work. `SMB_SEC=ntlmv2 fin vm mount`. Also see [unix.stackexchange.com/questions/124342](https://unix.stackexchange.com/questions/124342/mount-error-13-permission-denied/124352#124352)
* Improve messaging to show when database dump is being imported from stdin 
* Fix automatic VirtualBox installation on Windows
* Docksal console desktop icon is deprecated. With the winpty improvements there is no need in this experimental console approach anymore.
* Import SSH keys during containers reset on Linux (#180)
* `vhost-proxy` and `dns` are now binding to `192.168.64.100` on all platforms. This should help to avoid conflicts with local web server instances (assuming they also don't bind to `0.0.0.0`, but use a specific IP instead (e.g. Apache on Linux can now run on `127.0.0.1` in parallel with Docksal)

## Documentation

* How to increase Docksal VirtualBox VM disk size 
* Drush site aliases documentation improvements
* New edge case in Troubleshooting: `FastCGI: incomplete headers`
* Updated "Working with multiple projects/domains"
* Added "Stats and analytics" section


## 1.2.0 (2017-04-12)

### New features

- New one-line installer: `curl -fsSL get.docksal.io | sh`
- Docksal usage stats. Minimal OS/version and fin version tracking via Google Analytics.
- `fin debug` - a new hidden command for debugging purposes
- `fin exec` can now take a file as an argument and will execute it inside cli (e.g. `fin exec script.sh`)
- `fin vm mount` - a new hidden command to attempt re-mounting of shares on Mac and Windows.
- `fin project create` - replaces `fin create-site`
- `fin run-cli` - run a standalone, one-off cli container in the current directory. This allows using any tool inside cli without an already created/running Docksal project/stack.
- `fin image` command to manage images (save, load, view Docksal images on Docker Hub).
  - Adds support for saving and loading Docksal system and project images (e.g. from a local drive).
- Portable installation mode support (e.g. from a USB drive or a local folder)
  - Useful for conferences/trainings/etc. where internet bandwidth is an issue
  - `fin update` - supports VirtualBox, boot2docker.iso and tools (Mac and Windows)
  - `fin vm start` - load system images from a local `docksal-system-images.tar` file
- Magento support and [sample project repos](https://github.com/docksal/magento)

### Changes and improvements

- Version updates:
  - VirtualBox 5.1.18
  - Docker 17.04.0
  - Docker Compose 1.12.0
  - winpty-0.4.2-cygwin-2.6.1
- Default project stack version changes
  - `cli`: [docksal/cli:1.2-php5](https://github.com/docksal/service-cli/releases/tag/v1.2.0) and [docksal/cli:1.2-php7](https://github.com/docksal/service-cli/releases/tag/v1.2.0-php7)
- Soften Docker version requirements - allowing higher Docker versions, since Docker added backward API compatibility.
- `fin cleanup` is now executed on `fin update` to address weird cases when Docker is using outdated image versions. #155
- Added DNS settings for all services. Addresses the issue with containers not being able to resolve `.docksal` domains.
- Added support to disable pseudo-tty allocation with `fin exec -T`. Useful for non-interactive commands when output is saved into a variable for further comparison.
- Removed `--privileged --userns=host` from system services
- Refactored Docker environment variable export during startup. Startup time decreased by approx. 0.5s.
- Improvements to handle edge cases when mounting NFS shares on Mac.
- Windows
  - Support for pipes (`|`), stream redirects (`< >`) and variable substitution from a sub-shell ( `$()` ) via `winpty -Xallow-non-tty`
  - Fixed directory switch in `fin exec`
- Allowing non-tty installation on Mac and Linux (e.g. when used in CI/scripts)
- Miscellaneous other small fixes and improvements

### Documentation

- MySQL DB access for external tools
- Overriding the default domain name and Using arbitrary custom domains
- Web server logs, HTTP Basic Authentication
- Docksal setup instructions
- fin cli
- Troubleshooting
- Installing Docksal from a USB drive ("portable" mode) 
- Added Github issue and pull request templates


## 1.1.0 (2017-03-07)

### New features

- Global docksal.env
- Ability to skip VBox version check via `SKIP_VBOX_VERSION_CHECK=1` (add to `~/.docksal/docksal.env`)
- Wildcard virtual host support is on by default (i.e. )
- Added checks for the uniqueness of the project name and virtual host
- Added Magento sample project repo to `fin create-site`

### Changes and improvements

- Update software requirements
  - Docker 1.13.1, Docker Compose 1.11.1, Docker Machine 0.9.0, VirtualBox 5.1.14
- System services version changes
  - `docksal-vhost-proxy`: [docksal/vhost-proxy:1.0](https://github.com/docksal/service-vhost-proxy/releases/tag/v1.0.1)
- Default project stack version changes
  - `cli`: [docksal/cli:1.1-php5](https://github.com/docksal/service-cli/releases/tag/v1.1.0) and [docksal/cli:1.1-php7](https://github.com/docksal/service-cli/releases/tag/v1.1.0-php7)
- Removed `VIRTUAL_HOST` env variable from stack files and docs. Starting with `docksal/vhost-proxy:1.0` the `io.docksal.virtual-host` label is used instead. The `VIRTUAL_HOST` env variable can still be used (for compatibility reasons).
- Showing error for an unknown vm subcommand
- Fixes for updating on Ubuntu
- Added PROJECT_ROOT_WIN variable for certain use cases on windows
- Increased default VM disk size to 50GB
- Increased delay after nfsd restart on macOS
- Fixed the configuration statements order in `volumes-unison.yml`
- Fixed documentation search on ReadTheDocs

### Documentation

- Restructured docs
- Updated Xdebug documentation for drush debugging
- Added instructions on using Xdebug with NetBeans
- Added Drupal Console and Drush setup instructions


## 1.0.0 (2017-01-27)

First release.

**IMPORTANT:** Anyone switching from Drude please follow the [update steps](/docs/update-dde.md) precisely to avoid conflicts and issues.


## 1.0.0-rc2 (2017-01-20)

First release.

**IMPORTANT:** Anyone switching from Drude please follow the [update steps](/docs/update-dde.md) precisely to avoid conflicts and issues.


## 1.0.0-rc1 (2016-11-23)

First release.

**IMPORTANT:** Anyone switching from Drude please follow the [update steps](docs/update-dde.md) precisely to avoid conflicts and issues.
