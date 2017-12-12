# Changelog

# 1.6.1 (2017-12-12)

**IMPORTANT NOTE:** if you use VirtualBox you may have to run `fin update` **twice** for this release.

This release addresses a critical issue in 1.6.0, which breaks new Docksal installations on Mac/Windows using 
VirtualBox mode. We are also introducing support for WSL on Windows (in beta).

## New software versions

- fin v1.43.2

## New Features

- Windows: WSL (Windows Subsystem for Linux) support (beta)
- Docker for Mac, Unison volumes: `fin logs unison` - show Unison log

## Changes and improvements

- Check for `docker-machine` binary existence during vm stop on update
- Docker for Mac, Unison volumes: Added ability to wait for the initial sync to complete.
- Added ability to lock Docksal updates

    Set `DOCKSAL_LOCK_UPDATES` to anything in `$HOME/.docksal/docksal.env` to lock updates. Useful on CI/sandbox servers.

## Documentation

- Updated: Docker for Mac [Unison volumes](https://docs.docksal.io/en/v1.6.1/advanced/volumes/#unison-volumes)


# 1.6.0 (2017-12-08)

**IMPORTANT NOTE:** if you use VirtualBox you may have to run `fin update` **twice** for this release.

## New software versions

- fin v1.41.0
- docker/boot2docker v17.09.0-ce
- docker-compose v1.16.1
- docker-machine v0.13.0
- VirtualBox v5.1.28 (the latest boot2docker is using VirtualBox Guest Additions v5.1.28, so we stick with a matching version here as well)

## New Features

- `fin project` command subset replaces the old `fin start/stop/restart/rm` commands.

    The old commands are still supported to preserve compatibility.

- Docker for Mac: osxfs caching is automatically enabled to improve read performance. (#249, #397)
- Docker for Mac: [Unison file sync](http://docs.docksal.io/en/v1.6.0/advanced/volumes/#unison-volumes) support
- You can add environment dependent ENV and YML files based on `$DOCKSAL_ENVIRONMENT` variable, e.g. `docksal-myenv.yml`,
 that would only apply, if `DOCKSAL_ENVIRONMENT=myenv` (#383, #354). Official documentation is pending.
- New sample project repos and wizards: [Grav](https://github.com/docksal/example-grav), 
[Gatsby JS](https://github.com/docksal/example-gatsby) and [Laravel](https://github.com/docksal/example-laravel)
- New `vhosts` command to show all registered Docksal virtual hosts

## Changes and improvements

- Docker for Mac/Win: networking setup is now aligned with the VirtualBox mode and Linux:

```
  192.168.64.1 - host IP
  192.168.64.100 - Docksal IP
```

- Docker for Mac: Add ssh keys on up/restart/reset (#396)
- Docker for Mac/Win: Fixed xdebug settings. (#389, #393)
- Ubuntu 17.10: Install `ifupdown` and `resolvconf` if they are missing (#321)
- Ubuntu 17.10: Address slow fs performance with the `overlay2` storage driver (defaut in Docker for Mac/Win and Ubuntu 17.04+) by adding `/home/docker` volume in `cli` (#325)
- Addressed the DNS issue of corporate networks and VPN

    Added backup upstream DNS server for docksal-dns. This addresses cases when `DOCKSAL_DNS_UPSTREAM` is set to an internal IP (VPN/LAN) and becomes inaccessible when user disconnects from that network. `8.8.4.4` will now be used as a backup when DOCKSAL_DNS_UPSTREAM is not reachable.

- Exposed ngrok Web UI on a random port to make it accessible from the host  (#379)
- Project images are now auto-updated during overall update
- Show virtual host name after project start
- Allow installing Docksal addons from a non-default GitHub repo
- Allow any `exec_target` for addons and custom commands (#356).

    Requires that container specified as `exec_target` has `project_root` volume defined, just like cli:
    ```
        volumes:
          # Project root volume
          - project_root:/var/www:rw,nocopy
    ```

- Fixed version comparison bug
- Fixed MySQL permissions and default db missing bugs in `fin db create` (#351, #371, #372)
- Fixed the bug that Virtualbox update breaks docker-machine upgrade and users need to run `fin update` twice. (#280)
- Fin will check that Docksal system services (`dns`, `vhost-proxy`, `ssh-agent`) are running and restart them otherwise
- Use `DOCKSAL_DNS_DOMAIN` variable value for default `VIRTUAL_HOST` (#390)
- Fix that system images were not updated during install in Docker for Mac/Win mode
- Ensure `~/.ssh` exists. This prevents errors for users with no ssh keys
- Increase CLI healthcheck wait timeout to 60 seconds for intensive operations during custom healthchecks

## Documentation

- New: [Unison volumes](https://docs.docksal.io/en/v1.6.0/advanced/volumes/#unison-volumes)
- Updated: [SMB troubleshooting](https://docs.docksal.io/en/v1.6.0/troubleshooting-smb/) - SMBv1 issues on Windows 10 Fall Creators Update 1709
- Updated: Docker for Mac/Windows [file sharing](https://docs.docksal.io/en/v1.6.0/getting-started/env-setup-native/)
- Updated: [Getting a list of Docksal images on Docker Hub](https://docs.docksal.io/en/v1.6.0/advanced/stack-config/#docksal-images-and-versions)
- Updated: Switch to using https://get.docksal.io for installs
- Updated: [Portable installation instructions](https://docs.docksal.io/en/v1.6.0/getting-started/portable/)
  - Added support for Docker for Mac/Windows
  - Organized instructions per OS
- Updated: Improved [custom commands](https://docs.docksal.io/en/v1.6.0/fin/custom-commands/) documentation

# 1.5.1 (2017-09-06)

This is a hotfix release aimed to address sporadic issues with TLS certificates caused by a regression between 
docker-machine 0.12.0 and docker engine 17.06.0.

## New software versions

- docker-machine v0.12.2


# 1.5.0 (2017-08-24)

## New software versions

- fin v1.26.0
- Stack images updates
  - `web`: [docksal/web:2.1-apache2.2](https://github.com/docksal/service-web/releases) and [docksal/web:2.1-apache2.4](https://github.com/docksal/service-web/releases)

## New Features

- `--no-truncate` option for `fin db import`
- `fin db cli` now accepts query as an argument and `--db` parameter to specify the database to run query against
- `fin db create` and `fin db drop` commands
- `fin diagnose` command

## Changes and improvements

- Basic automated test in example repos
- Removed old icon scripts on for Windows
- Made `DOCROOT` variable accessing in `cli`

## Documentation

- New: [Troubleshooting SMB shares creation, mounting and related issues on Windows](http://docs.docksal.io/en/v1.5.0/troubleshooting-smb)
- New: [Web server: Configuration overrides](http://docs.docksal.io/en/v1.5.0/advanced/web-configuration-overrides) 
- Updated: `fin db` docs regarding `--no-truncate`
- Updated: added recommendations for running custom commands in `cli`


# 1.4.0 (2017-08-03)

## Breaking changes

For custom configurations (using `docksal.yml`), if you are getting:

```bash
ERROR: Named volume "host_home:/.home:ro" is used in service "cli" but no declaration was found in the volumes section.
```

Remove `host_home:/.home:ro` from `docksal.yml` and do a `fin project start`.

## New software versions

- docker v17.06.0-ce
- docker-compose v1.14.0
- docker-machine v0.12.0
- VirtualBox v5.1.22
- winpty-0.4.3-cygwin-2.8.0-ia32
- fin v1.22.0
- System and stack images updates
  - `vhost-proxy`: [docksal/vhost-proxy:1.1](https://github.com/docksal/service-vhost-proxy/releases) 
  - `web`: [docksal/web:2.0-apache2.2](https://github.com/docksal/service-web/releases) and [docksal/web:2.0-apache2.4](https://github.com/docksal/service-web/releases)
  - `db`: [docksal/db:1.1](https://github.com/docksal/service-db/releases)
  - `cli`: [docksal/cli:1.3-php5](https://github.com/docksal/service-cli/releases) and [docksal/cli:1.3-php7](https://github.com/docksal/service-cli/releases)

## New Features

- Implemented a Docker healthcheck for cli
  - Requires docksal/cli v1.3.0+. Falls back to waiting for 10s for the container to become ready for older versions.
- Addons (experimental)
  - Ability to install and remove addons (custom commands) per project or globally from statically defined repo docksal/addons
- Prevent NFS conflicts on macOS. (#133)
  - `DOCKSAL_NFS_PATH` can be used to override Docksal projects folder which effectively serves as NFS mount point. 
- Added support for simple static site creation in `fin project create` (#177)
- Added custom commands to bash autocomplete (#232)
- `fin sql-import --progress`
  - `--progress` displays import progress using `pv` (if installed on the host)
- `fin build` - support for `docker-compose build` workflow
- Support for executing custom commands in `cli` instead of host
  - Add `#: exec_target = cli` in the header of the custom command to tell fin to execute the command within `cli` via `fin exec`

## Changes and improvements

- The VM on Mac and Windows will now use 2GB of RAM by default
  - Anyone who's low on RAM (< 8GB) can use `fin vm ram 1024` to limit the VM memory to 1GB
- Use `nocopy` mode for `project_root` volume
  - This tells Docker to not merge the content of the volume with the destination directory in the container (if one is not empty)
- SSH Agent usage refactoring
  - Removed dependency on the host's `$HOME` directory mount.
- `host_home` volume is deprecated and removed from stack files
  - **This is a breaking change!**
  - See instructions above on the necessary adjustments to `docksal.yml`. 
- Ability to stop at restart certain service container, e.g. `fin restart db`
- Fix mysql import for large database (#279)
  - Database truncation was rewritten. Now database will be dropped and re-created. Should work faster and more reliable.
- Mysql import and dump functions will properly read `MYSQL_DATABASE` environment variable (#276)
- Temporary workaround for NFS issues on Mac (#265)
- Fixed the install/update process handling when Docker is already installed (#298)
- Other fixes and improvements 

## Documentation

- New: [Extending stock images](http://docs.docksal.io/en/v1.4.0/advanced/extend-images)
- New: [Folder aliases](http://docs.docksal.io/en/v1.4.0/advanced/folder-aliases)
- New: [File sharing](http://docs.docksal.io/en/v1.4.0/advanced/file-sharing)
- Updated: Docker for Mac, Solr, Memcached, Behat and Blackfire docs
- Updated: Troubleshooting with mysql memory edge case


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
