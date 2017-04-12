# Changelog

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
