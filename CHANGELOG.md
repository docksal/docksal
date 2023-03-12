# Changelog

## 1.18.0 (2023-03-12)

### New software versions ✨

- fin v1.112.0
- Docker Desktop v4.17.0
- Docker v20.10.23
- Docker Compose v2.15.1
- VirtualBox v6.1.42
- New image versions
  - [docksal/cli v3.3](https://github.com/docksal/service-cli/releases/tag/v3.3.0)
- Switched all stacks to PHP 8.1 (`docksal/cli:php8.1-3.3` image)

### Changes and improvements ⚙️

- macOS Ventura 13.0 compatibility
  - Adjusted NFS mount read/write buffers
- Ubuntu 22.04 compatibility
- Made `DOCKSAL_ENVIRONMENT` variable visible in custom commands and add-ons by default
- Updated Solr version to v7 for the Acquia stack
- Fixed `fin image registry <image_name>` command
- Fixed `fin share` command
- Fixed network settings in Gitpod
- Updated the list of options for `fin project create` (added Drupal 10 options, removed Drupal 8)
- Updated `xhprof` image to work with arm64/Apple Silicone
- Switched `cloudflared` service to the official `cloudflare/cloudflared` image (which now supports arm64)
- Dropped legacy xdebug v2 `remote_host` option in stack configs
- Improved fin sysinfo output (added green/red colors for PASS/FAIL tests)

### Documentation 📖

- Adding Mutagen option in [Shared Volumes](https://docs.docksal.io/core/volumes/) docs
- Updated PHP version docs
- Removed Solr 4 instructions and updated the listed default version to Solr 8
- Various small updates

### Contributors 🤓

@lmakarov, @froboy, @paulsheldrake, @shelane, @halisonfernandes, @obriat, @khaledzaidan, @nicoschi, @shaal, 
@matthiasseghers, @eloso-uk, @sean-e-dietrich, @danshumaker, @rosenstrauch, @jasonawant, @anpolimus, 

### Sponsors 🤑

@markaspot, @lpeabody, @alexander-danilenko, @andreyzb, @twfahey1, @johnoltman65, [❤️ You ❤️ ](https://github.com/sponsors/docksal)


## 1.17.0 (2022-04-15)

### New software versions ✨ 

- fin v1.110.1
- Docker Desktop v4.4.2+ (build 73305)
- Docker v20.10.12 (boot2docker pinned at v19.03.5)
- Docker Compose v2.1.0
- VirtualBox v6.1.32
- New multi-arch (amd64/arm64) image releases
  - [docksal/vhost-proxy v1.8](https://github.com/docksal/service-vhost-proxy/releases)
  - [docksal/ssh-agent v1.4 ](https://github.com/docksal/service-ssh-agent/releases)
  - [docksal/dns v1.2](https://github.com/docksal/service-dns/releases)
  - [docksal/cli v3.2](https://github.com/docksal/service-cli/releases)
  - [docksal/apache v2.5](https://github.com/docksal/service-apache/releases)
  - [docksal/nginx v1.2](https://github.com/docksal/service-nginx/releases)
  - [docksal/mysql v2.0](https://github.com/docksal/service-mysql/releases)
  - [docksal/mariadb v1.3 ](https://github.com/docksal/service-mariadb/releases)
  - [docksal/varnish v3.1](https://github.com/docksal/service-varnish/releases)
- PHP 8.1 is now the default version in the `default` stack and in `fin run cli` command
  - See docs on [switching/pinning PHP versions](https://docs.docksal.io/service/cli/settings/#php-versions)

### Changes and improvements ⚙️ 

- 🎉 Apple M1 and Linux ARM64 support 🎉 
  - All services in the Docksal catalog (except `solr` and `mailhog`) now use multi-arch (amd64/arm64) images
- Switched to Docker Compose v2 (v1 support dropped)
  - Running v2 in compatibility mode (forces the use underscores instead of hyphens in container names (like in v1)).
- Use of `.docksal` base domain along with `docksal-dns` internal DNS resolver is deprecated
  - Follow the [instructions](https://docs.docksal.io/stack/configuration-variables/#docksal-dns-disabled) to switch to the new public base domain - `.docksal.site`
- New `fin share-v2` command
  - Creates a temporary public URL for the project using a free Cloudflare Tunnel
- Project auto-start is now disabled by default for local environments (still ON by default for CI environments)
- Included Docksal version in `fin --version` output
  - no more confusion which Docksal vs fin version you are running
- Gitpod Integration
- `fin pull` is now an [addon](https://github.com/docksal/addons) (removed from fin core)
- Fixed VirtualBox support on macOS 12 Monterey
- Removed Drupal 8 options from `fin project create` (Drupal 8 is EOL)
- Bumped all services to the most recent image tags
  - We'll stick to the most recent versions by default and pin versions in hosting platform specific stacks
  - Current default versions:
    - Apache 2.4
    - Nginx 1.20
    - MySQL 8.0
    - MariaDB 10.6
    - Postgres 14.2
    - PHP 8.1
    - Varnish 7.0
    - Memcached 1.6
    - Redis 6.2
    - Solr 8.6-edge (legacy image, likely to be deprecated)
    - Mailhog 1.0.1
    - Elasticsearch 8.1.2
    - cloudflared `latest` (has to stay on `latest` as Cloudflare makes frequent updates and blocks older client versions)
- Switched to MariaDB 10.4 as the default `db` service in all hosting platform stacks
  - MariaDB 10.4 functions as limited drop-in replacements for MySQL 5.7, as far as InnoDB is concerned
- Updated Acquia stack versions
  - Apache 2.4
  - MariaDB 10.4 (MySQL 5.7 drop-in replacement)
  - PHP 7.4
  - Varnish 6.6
  - Memcached 1.6
  - Apache Solr 4.5
- Updated Pantheon stack image versions
  - Nginx 1.20
  - MariaDB 10.4 (MySQL 5.7 drop-in replacement)
  - PHP 7.4
  - Varnish 6.6
  - Redis 5.0
  - Apache Solr 3.6
- Updated Platform.sh stack image versions
  - Nginx 1.20
  - MariaDB 10.4 (MySQL 5.7 drop-in replacement)
  - PHP 7.4
  - Redis 5.0
- Switched to Blackfire Agent v2 in stacks (requires docksal/cli [v3.1.0](https://github.com/docksal/service-cli/releases/tag/v3.1.0)+)

### Documentation 📖 

- Expanded docs around project auto start/stop features
- Added instructions for installing an addon globally
- Added documentation on composer memory issues
- Reorganized and updated help sections in fin + misc updates in `fin help`
- Added disk space issue to common issues
- Updated MailHog docs 
- Added Github Actions build badge in README.md
- Added section on common issues for Apple MDM (Mobile Device Management) troubleshooting
- Updated docs around disabling built-in DNS resolver (docksal-dns)
- Added Cloudflare Tunnel (`fin share-v2`) docs
- Added example on how to override `solr` service image
- Added sponsor documentation

### Contributors 🤓 

- @lmakarov, @sean-e-dietrich, @shelane, @froboy, @waako, @marvoey, @paulsheldrake, @vladtulku, @JDDoesDev 

### Sponsors 🤑 

- @markaspot, @froboy, @lpeabody, @alexander-danilenko, @paulsheldrake, @610, @twfahey1, @johnoltman65
- [❤️ You ❤️ ](https://github.com/sponsors/docksal)


## 1.16.2 (2021-09-28)

### New software versions

- fin v1.107.1

### Changes and improvements

- Fixed terminal colors in `fin` broken on some systems after update to v1.16.1


## 1.16.1 (2021-09-27)

### New software versions

- fin v1.107.0

### Changes and improvements

- Use `ifconfig` command instead of `ip` command on Mac
- Minor refactoring in Github Actions
- Minor changes to UI in `fin`
  - Revised terminal colors and notification types

### Documentation

- Simplified troubleshooting docs around Docker Machine TLS certs
- Replaced references to Gitter with GitHub Discussions
- Added documentation for the `HOSTING_*` variables on the configuration variables page


## 1.16.0 (2021-08-03)

### New software versions

- fin v1.106.0
- Docker Desktop v3.4.0 (65384)
- Docker v20.10.7
- Docker Compose v1.29.2
- VirtualBox v6.1.22
- Switched `vhost-proxy` service to [docksal/vhost-proxy:1.7](https://github.com/docksal/service-vhost-proxy/releases/tag/v1.7.0) (multi-arch amd64/arm64 image)
- Switched `cli` service and `run-cli` command to [docksal/cli:php7.4-3.0](https://github.com/docksal/service-cli/releases/tag/v3.0.0)
  - **This is a major version upgrade of the image**
  - arm64 support
  - PHP 8.0 image
  - Xdebug v3 PHP extension
  - Dropped some tools, not all tools available for arm64, terminus not available for PHP 8.0
- Switched `mysql` service to [docksal/mysql:5.7-1.5](https://github.com/docksal/service-mysql/releases/tag/v1.5.0)

### New features

- Switched [stack files](https://github.com/docksal/docksal/tree/develop/stacks) to Docker Compose file format v3.9
  - As the `"version"` property is now optional, this change is fully backwards compatible with the existing `2.1` stack files.
  - Moved `dns`, `healthchecks`, and `logging` settings into `x-common-settings` in `services.yml` (yaml anchors are now supported!)
- Platform.sh alike stack (`stack-platformsh.yml`) based on [platformsh-templates/drupal9](https://github.com/platformsh-templates/drupal9)
- `fin acli` to top level command (using [acquia/cli](https://github.com/acquia/cli))

### Changes and improvements

- Switched from Travis CI to Github Actions for CI/CD
- Enhanced NFS diagnostics in `fin sysinfo`
  - Showing `nfsd status` and `showmount -e`
- Allow addons/scripts to use variables and functions defined in `fin` by sourcing it (`source $(which fin)`)
- Removed deprecated `services/web`
- Fixed NFS mounts with Docker Desktop (Virtualization Framework/M1) in macOS Big Sur
- Added check for existing host name before adding to eliminate duplicates
- Replaced `which` with `command` in shell function wrappers (`pwd`, `docker`, `docker-compose`) (#1496)
- Dropped `docker-machine` wrapper, as microsoft/WSL#4078 is now resolved.
- Fixed exit code at the end of `fin update` - without this, `fin update` would exit with `0` even if there were errors during the update process.
- Updated XHProf service to work with XHProf 2.x and 3.x (#1507)
- Updated IDE settings for XDebug v3 compatibility
- Preserving compatibility with XDebug v2
  - This will prevent breaking changes for custom stacks or stacks that pin the `CLI_IMAGE` version to a version with XDebug v2 (`docksal/cli` v2.12 and below).
- Added sponsor prompt after `fin update`
- Using `busybox` instead of `docksal/empty` image in `is_docker_path` check (busybox is multi-arch)
Included WSL in Windows usage reporting

### Documentation

- Added documentation for Xdebug 3
- Added documentation for Platform.sh alike stack
- Bumped WSL Ubuntu v20.04 in docs
- Added warning for changing volume mount type (#1486)
- Update docs for Acquia CLI ([acquia/cli](https://github.com/acquia/cli)) and add to top level commands (#1481)
- Updated drush links in doc for `fin pull`
- Blocked search engines on feature/version branches of the docs
- Added a redirect for a most common URLs linking to the [old RTD docs website](https://docksal.readthedocs.io/)
- Added documentation version link for develop branch as "Upcoming"
- Added example and help on obtaining info on latest available images
- Added documentation on routing to a custom port (#1526)
- Created `CODEOWNERS`
- Added Feedback button in docs (#1527)
- Switched to CarbonAds in docs
- Switches community support to GitHub discussions
- Added GitHub Discussions link to docs sidebar menu


## 1.15.1 (2021-01-15)

### Changes and improvements

- Added `COMPOSER_DEFAULT_VERSION` in `services.yml` to support Composer version switching instructions in docs
- Improved flushing DNS cache on macOS
- `fin sysinfo` improvements
  - rearranged items to be more logical
  - print NFS settings for macOS regardless of the mode (VBOx or Docker Desktop)
  - print `DOCKER_HOST` unconditionally (may be helpful in any case)
  - list all projects, not just active
  - added connectivity checks
  - added debug information if host DNS check fails
- Added container logging options to `docksal-dns` and `docksal-ssh-agent` services
- Added `DOCKSAL_CONTAINER_HEALTHCHECK_INTERVAL` option
  - Can be used to increase container healthcheck interval and thus help with excessive load produced by healthchecks from many concurrently running containers.
  - Defaults to 10s
- Minor improvements in tests

### Documentation

- Moved Composer version docs to tools/composer
- Added "Applications" section
  - Moved Drupal and Wordpress docs to a new section
  - Added Wordpress HTTPS docs
- Fixed links and typos in docs


## 1.15.0 (2020-11-20)

### New software versions

- fin v1.102.0
- Docker Desktop v2.5.0.1 (49550)
- Docker v19.03.13 (boot2docker pinned at 19.03.5)
- Docker Compose v1.27.4
- VirtualBox v6.1.16
- Switched `cli` service to `docksal/cli:2.12-php7.3`
  - Dropped PHP 7.2 (EOL as of 30 Nov 2020)
  - Added Composer v2 (default) with ability to pin to Composer v1
  - Updated NodeJs to the latest LTS release v14.15.0
  - Version bumps for other console tools and runtimes
  - See https://github.com/docksal/service-cli/releases/tag/v2.12.0 for  more details.
- Switched `postgres` service to `postgres:10.14-alpine`
  - Drupal 9 requires PostgreSQL 10+

### New features

- macOS Big Sur support

### Changes and improvements

- Update for Elasticsearch 7 compatibility
- Adjusted approach to mounting ssh-agent socket in cli (#1391)
- Prevent PTY allocation for mysql when no TTY is available (#1394)
- Fixed `SSH_AUTH_SOCK_DIR` owner in cases when the volume directory has been already created by docker (root user)
- Fixed target repositories to match project create selection
- Increased precision in `ver_to_int` to 4 positions to correctly handle Docker Desktop's a.b.c.d (4 positions) version schema
- Fixed `docker_desktop_version` check on Windows for recent Docksal Desktop versions
- Fixed bind mounts on Docker Desktop for Mac/Windows v2.3.0.2+
- Changed the value for `DOCKASL_VOLUME=disabled` ("DOCKASL_VOLUME=disable" => "DOCKASL_VOLUME=disabled")
- Removed Acquia drush commands (Acquia Cloud API v1 is EOL)
- Added support for branch name when using a custom git repo in `fin project create`

### Documentation

- Updated troubleshooting docs on conflicting ports (how to identify which process uses a port)
- Updated VPN troubleshooting docs
  - Mentioned that the VPN workaround is only possible with Docker Desktop for Mac/Windows (see #1397)
- Added docs for missing SSE4.2 CPU instruction set (#1414)
- Fixed Dockerfile example to use proper shell in "Extending Stock Images" docs
- Fixed ssh-key help message
- Added documentation for the Acquia CLI tool (#1387)
- Using entirely custom docker-compose configurations
- Refactored stack configuration docs
- Added Composer version docs in service/cli/settings
- Fixed internal linking in docs
- Wordpress multisite settings
- Updated project's README on GitHub


## 1.14.1 (2020-07-20)

### New software versions

- fin v1.99.0

### New features

- Updated projects to include Drupal 9 boilerplate projects (#1385)

### Changes and improvements

- Reverted back to using IP binding for system services with VirtualBox/boot2docker
  - Only use `0.0.0.0` for vhost-proxy and dns with Docker Desktop 2.2.0.0+ on Mac/Windows
- Bump `REQUIREMENTS_DOCKER_DESKTOP` to 2.1.0.5
  - This is the last version before networking regressions were introduced (#1268)
- Split docker versions based on environment (Linux, Docker Desktop, Boo2docker)
  - `REQUIREMENTS_DOCKER='19.03.9'` - this is the earliest version available for Ubuntu 20.04 (focal) LTS
  - `REQUIREMENTS_DOCKER_DD='19.03.8'` - this is the latest version available with Docker Desktop
  - `REQUIREMENTS_DOCKER_B2D='19.03.5'` - this is the final boot2docker version
  - Removed `REQUIREMENTS_DOCKER_DEBIAN`
- Better handling of `ID_LIKE` in `is_debian` (#1377)
- Added "DOCKSAL: NETWORKING" sections in sysinfo …
  - Replaced "DOCKSAL: DNS"
  - Prints network config variables
  - Added check for DNS resolution/connectivity from containers (and not only host)
- Added dns settings for run-cli

### Documentation

- Updated versions in setup docs
  - Added a note in setup docs about Docker Desktop version regressions


## 1.14.0 (2020-07-15)

### New software versions

- fin v1.97.0
- VirtualBox v6.1.10
- docker v19.03.5 (v19.03.9 on Debian/Ubuntu)
- docker-compose v1.26.0
- Switched `vhost-proxy` to [docksal/vhost-proxy:1.6](https://github.com/docksal/service-vhost-proxy/releases/tag/v1.6.0)
- Switched `cli` image to [docksal/cli:2.11-php7.3](https://github.com/docksal/service-cli/releases/tag/v2.11.0)

### New features

- Ubuntu 20.04 (focal) LTS support
- PHP 7.4 ([docksal/cli:2.11-php7.4](https://github.com/docksal/service-cli/releases/tag/v2.11.0))
- Xhprof integration (#1270)
- Project autostart switch (#1285)

### Changes and improvements

- Added `DOCKSAL_DNS_DISABLED` global config switch to allow disabling the build-in `docksal-dns` service (#1376)
  - Use this as a transition to the new `docksal.site` base domain for projects
  - Helps address the DNS port binding issue on macOS (`listen udp 0.0.0.0:53: bind: address already in use`)
- Added proxy variables to `fin run-cli` (#1252)
- Passing the database argument when running `fin db cli` (#1263)
- Changed uuid generation method (#1287)
- Added a check that the VM IP matches what we expect
- Fixed issue "error while removing network: network id has active endpoints" (#1293)
- Fixed environment variables for `fin exec` running scripts (#1289)
- Fixed issue with starting `cli` from `vhost-proxy` and missing ssh agent socket (#1291)
- Fixed logic with `SSH_AUTH_SOCKET` (#1308)
- Allow overriding `DOCKSAL_DNS_DOMAIN` with Docker Desktop 2.2.0.0+
  - If users want to stick with the `.docksal` TLD on Docker Desktop for Windows, they can do so by manually pinning `DOCKSAL_DNS_DOMAIN` (`fin config set --global DOCKSAL_DNS_DOMAIN=docksal`) and then use `fin hosts add project.docksal` to manage DNS records using the OS hosts file.
- Added logging settings for system containers (#1354)

### Documentation

- Added a section for locally-trusted HTTPS certs using `mkcert` (#1370)
- Explained SSH agent proxy functionality (#1253)
- Added a section for xhprof (#1270)
- Updated NFS mounts and configuration (#1261)
- Added troubleshooting docs for NFS issues on macOS Catalina (#1371)
- PostreSQL support in stacks (#564)
- Configuration information for Nginx
- Lots minor fixes in docs
- ElasticSearch persistent settings
- Docker container logging
- Adding a custom certificate for a project (#1359)
- Accessing environment variables in cron jobs (#1365)
- Updated DNS settings docs (#1376)


## 1.13.3 (2020-05-14)

### New software versions

- fin v1.95.0

### Changes and improvements

- Docker Desktop 2.3.0.2 compatibility fixes (Mac and Windows)
  - Bind system services to `0.0.0.0` by default in virtualized environments (fixes #1268, fixes #1342)
  - Dropped the dependency on DockerNAT interface on Windows (fixes #1276) 
    - Do not configure DNS resolver with Docker Desktop for Windows
    - Use the external `docksal.site` TLD with Docker Desktop for Windows v2.2.0.0+. This is necessary to have a working setup out of the box without the need to ask the user to manually configure DNS records using "fin hosts".

### Experimental

- Try the new external TDL for your Docksal projects!
    ```
    fin config set --global DOCKSAL_DNS_DOMAIN=docksal.site
    ```
    Note: This option is enforced with Docker Desktop for Windows 2.2.0.0+


## 1.13.2 (2019-03-15)

### Documentation

- Added a section about setting/checking `DOCKSAL_VOLUMES` (#1275, #1296)
- Added warnings in install docs about Docker Desktop versions (#1268)


## 1.13.1 (2019-12-17)

### New software versions

- fin v1.93.0

### Changes and improvements

- Added `IDE_PASSWORD` variable to IDE stack file (#1241)
- Fixed Xdebug configuration issues (#1242)
  - Updated `PHP_IDE_CONFIG` variable in `services.yml`
  - Added back xdebug settings workaround for backward compatibility (https://github.com/docksal/docksal/issues/1238#issuecomment-566779905)
- Fixed `SSH_AUTH_SOCK` being unset for custom commands (#1248)
- Improved performance and functionality of `fin bash` (#1247)
- Added `user` and `shell` labels on `cli` in `sercvice.yml`
- Improved messaging in `ssh_key()`
- Cleaned up items pending to be removed as per TODO notes

### Documentation

- Revamped Xdebug docs


## 1.13.0 (2019-11-27)

### New software versions

- fin v1.92.2
- docker v19.03.4, docker-compose v1.24.1, docker-machine v0.16.2 
- VirtualBox v5.2.34
- System services
  - [docksal/ssh-agent:1.3](https://github.com/docksal/service-ssh-agent/releases)
    - TCP proxy mode for SSH agent socket
- Stack services
  - Switched cli to docksal/cli:2.10-php7.3 - **PHP 7.3 is now the default version in all PHP stacks**
    - Switched to Debian 10 (Buster) based upstream PHP-FPM images
    - PHP 5.6 and 7.0 and no longer supported
      - `docksal/cli:2.6-php5.6` and `docksal/cli:2.6-php7.0` are the last images that included these EOL PHP versions
    - VS Code Server integration
      - See [Coder Web IDE docs](https://develop.docs.docksal.io/tools/ide/) for more details
    - Updated versions for cli tools
    - Updated xdebug (v2.7.2), so it works with PHP 7.3 (docksal/docksal#1105)
    - Added sqlsrv/pdo_sqlsrv extensions for PHP 7.3
    - See docksal/cli v2.7.0+ [release notes](https://github.com/docksal/service-cli/releases) for more details

### Changes and improvements

- Switched Docker Desktop to NFS volumes on Mac by default. See [volumes docs](https://docs.docksal.io/core/volumes/) for more details.
  - Existing Mac users will need to manually switch to NFS mode. This ensures we do not break existing project stacks as the switch requires a `fin project reset`.
- IDE mode overhaul
  - IDE runs in a separate container instead of inside `cli`
  - Requires `docksal/cli` v2.10+
  - IDE URL is now `http://ide-${VIRTUAL_HOST}` (using dash instead of dot separator in the URL)
  - IDE URL is printed along with Project URL after "fin up" in the console output (when `IDE_ENABLED=1`)
- Implemented ssh-agent forwarding on Linux, Mac and Windows
  - Added `DOCKSAL_SSH_AGENT_USE_HOST` variable to control which ssh-agent is used (host vs docksal) (#1080). See [variables docs](https://docs.docksal.io/stack/configuration-variables/#docksal-ssh-agent-use-host) for usage details.
  - Implemented an SSH proxy over TCP to support this use case on Mac and Windows (#1088)
- Allowed creating projects from a custom git repo (#1154)
  - Example: `fin project create --name=myproject --repo=https://github.com/org/project.git`
- Fixed a regression in git binary detection on Mac (#1084)
- Fixes in provider integrations (`fin pull`)
  - switched to `drush8` for Acquia pull commands (#1087)
  - fixed issue where date on cached db isn't checked properly (#1092)
  - fixed issue with backup ID retrieval in `provider_pull_acquia_db()` (#1093)
- Increased custom command finding depth from 2 to 4 (#1116)
- Fixed compatibility with WSL in Windows 10 v1903 (#1103)
- Fixed installation issues on Play-with-Docker / Alpine (#1233)
- Added IPv6 localhost termination in `fin hosts add` (#766)
- Added `DRUSH_OPTIONS_URI` to the cli service (#1115)
- Including MySQL settings in `cli` service definition
  - With MySQL settings visible in `cli`, they can be assumed from the environment instead of having to hard-code in app code
- Generating actual default init script file in the init wizard
- Added `IMAGE_RUN_CLI` variable which can be used to override the image via the global `docksal.env`
- Added `fin config yml` as a quick way to export static config (#728)
- Added `DOCKSAL_CONFIRM_YES` variable to allow auto-answering yes to all yes/no confirms (#1186)
- Added Drupal 8 BLT version for project create option (#1175)
- Added `--quiet` option for fin ssh-key add command (#1179)
- Made health check timeout configurable (#1178)
- Allowed setting shell and user for `fin exec` and `fin bash` commands using `io.docksal.shell` and `io.docksal.user` container labels (#1122)
- Refactored tests, made them faster, simpler (#1207)
- Fixed the issue with `osxfs:cached` and named volumes (#1218)
- Allowed VM primary and secondary storage capacity to be configurable. (#1222)
- Switched travis build to ubuntu 18.04 (bionic)
- `DOCKSAL_LOCK_UPDATES=1` now disables checks for updates. Previously, it would check, but not allow an update (#1081)
- Added a prompt to review release notes after update
  - Also opening release notes URL in a browser after update on Macs

### Documentation

- "Getting Started" docs overhaul
  - Aiming for a straightforward experience for new users
  - Two paths: 1) from scratch/existing project, 2) from a boilerplate repo
  - Putting emphasis on `fin init` as a single step to bootstrap a project "from zero to hero"
- Revamped volumes documentation (#1221)
- Revamped variables documentation, added variable scope (#1173)
- Added Acquia BLT documentation (#1190)
- Added documentation for Portainer (#1170)
- Added macOS firewall troubleshooting docs (#1196)
- Added VPN troubleshooting docs (#1203)
- Added documentation on multisite setup (#1209)
- Added VS Code documentation (#1212)
- Added WordPress settings documentation (#1144)
- Added wording about what an addon is
- Added documentation on passing environment variables (#1128)
- Added message about RAM needed for composer projects (#1189)
- Added notice about spaces in project paths (#1134)
- Changed link of sample projects to the Docksal boilerplate list on Github (#1139)
- Updated boilerplate repo URLs
- Added warning about required index page in docroot in zero-config docs section (#1141)
- Updated `ngrok.yml` config file documentation (#1100)
- Documented the cli `startup.sh` script (#751)
- Updated xdebug docs (#1158)
- Updated phpcs docs (#1160)
- Removed `fin vm ip` command from documentation and listed the canonical Docksal IP
- Fixed URL to edit docs
- Remove Babun mentions (#1204)


## 1.12.3 (2019-06-12)

**RELEASE CONTAINS BREAKING CHANGES**

There was a breaking change in Docker 18.09.0.  
If you are using VirtualBox mode (Boot2Docker), your VM will need to be reset during the update.  
See [Boot2Docker update](https://docs.docksal.io/troubleshooting/boot2docker-update/) for more information.

**DEPRECATION NOTICE**

- Versions of Windows prior to Windows 10 are no longer supported
- Babun (Windows) is deprecated and is no longer supported
- WSL is now the default and the only supported installation mode on Windows

### New software versions

- fin v1.86.2

### Changes and improvements

- Fix condition in `fin exec` that prevented executing a command in an arbitrary container (#1074)
- Call `xargs` in a cross-platform compatible way in fin cleanup (#1076)

### Documentation

- Updated `fin` command docs
- Updated stock stacks description


## 1.12.2 (2019-06-05)

**RELEASE CONTAINS BREAKING CHANGES**

There was a breaking change in Docker 18.09.0.  
If you are using VirtualBox mode (Boot2Docker), your VM will need to be reset during the update.  
See [Boot2Docker update](https://docs.docksal.io/troubleshooting/boot2docker-update/) for more information.

**DEPRECATION NOTICE**

- Versions of Windows prior to Windows 10 are no longer supported
- Babun (Windows) is deprecated and is no longer supported
- WSL is now the default and the only supported installation mode on Windows

### New software versions

- fin v1.86.0

### Changes and improvements

- Allowed custom commands and addons to be located in symlinked directories (#1036)
- Added a missing `--rm` in a `docker run` call in `is_docker_path` to cleanup existed containers (#1039, #1064)
- Refactored `fin cleanup`
  - Not cleaning up dangling volumes not created/managed under Docksal (#1056)
- Improve error reporting:
  - Error out if `DOCKSAL_STACK` definition is incorrect (#1051)
  - Error out `fin exec` if target container is not found (#1051)
- Removed `UNISON_USER` and `UNISON_GROUP` from `volumes-unison.yml` (#1049)
  - They are not needed anymore due to docksal/unison#7
- Reverted to using `wmic.exe` to get logical drives list on Windows (#1059)
- Added a trigger to short `fin pull` tests in CI

### Documentation

- Added docs on available Docksal Stock Images https://docs.docksal.io/stack/images-versions/
- Updated docs on the `DOCKSAL_ENVIRONMENT` variable use cases (#1041)
- Updated docs for web service settings and multiple webs use case
  - Added a more meaningful example for additional virtual hosts with Apache
  - Added Nginx docs
- Updated docs on NodeJS use case in `cli`
- Updated Windows SMB Troubleshooting docs with a case when drives are not shared in Docker Desktop (#1040)
- Update `fin config` docs (#1035)


## 1.12.1 (2019-04-09)

**RELEASE CONTAINS BREAKING CHANGES**

There was a breaking change in Docker 18.09.0.  
If you are using VirtualBox mode (Boot2Docker), your VM will need to be reset during the update.  
See [Boot2Docker update](https://docs.docksal.io/troubleshooting/boot2docker-update/) for more information.

**DEPRECATION NOTICE**

- Versions of Windows prior to Windows 10 are no longer supported
- Babun (Windows) is deprecated and is no longer supported
- WSL is now the default and the only supported installation mode on Windows

### New software versions

- fin v1.85.1

### Changes and improvements

- Added missing `stack-pantheon.yml` file to the list of stacks to download during update/install
- Fixed VirtualBox 6.0 compatibility in `fin vm rm`
  - Note: The official latest stable and supported VirtualBox version is still 5.2.26.
- Fixed DNS detection on Windows

### Documentation

- Updated installation docs
- Made Docker Desktop the recommended option for Mac users (to match the info on docksal.io)


## 1.12.0 (2019-04-04)

**RELEASE CONTAINS BREAKING CHANGES**

There was a breaking change in Docker 18.09.0.  
If you are using VirtualBox mode (Boot2Docker), your VM will need to be reset during the update.  
See [Boot2Docker update](https://docs.docksal.io/troubleshooting/boot2docker-update/) for more information.

**DEPRECATION NOTICE**

- Versions of Windows prior to Windows 10 are no longer supported
- Babun (Windows) is deprecated and is no longer supported
- WSL is now the default and the only supported installation mode on Windows

### New software versions

- fin v1.85.0
- Docker v18.09.2
- Docker Compose v1.23.2
- Docker Machine v0.16.1
- VirtualBox v5.2.26
- System services
  - [docksal/dns:1.1](https://github.com/docksal/service-dns/releases)
    - Switched base image to Alpine 3.9
  - [docksal/ssh-agent:1.2](https://github.com/docksal/service-ssh-agent/releases)
    - Switched base image to Alpine 3.9
  - [docksal/vhost-proxy:1.5](https://github.com/docksal/service-vhost-proxy/releases)
    - New neutral landing pages (goodbye "flask" and "grim reaper")
    - Tests and automation overhaul
- Stacks
  - [docksal/apache:2.2](https://github.com/docksal/service-apache/releases/tag/v2.2.0)
  - [docksal/apache:2.3](https://github.com/docksal/service-apache/releases/tag/v2.3.0)
  - [docksal/cli:2.6-php7.2](https://github.com/docksal/service-cli/releases/tag/v2.6.0)
  - [docksal/solr:2.0](https://github.com/docksal/service-solr/releases/tag/v2.0.0)
  - [docksal/varnish:2.0](https://github.com/docksal/service-varnish/releases/tag/v2.0.0)
- Boilerplates
  - Updated [docksal/boilerplate-drupal8-composer](https://github.com/docksal/boilerplate-drupal8-composer) to 8.6.10
  - Updated [docksal/boilerplate-drupal8](https://github.com/docksal/boilerplate-drupal8) to 8.6.10
  - Updated [docksal/boilerplate-drupal7](https://github.com/docksal/boilerplate-drupal7) to 7.63
  - Updated [docksal/boilerplate-drupal7-advanced](https://github.com/docksal/boilerplate-drupal7-advanced) to 7.63
- Addons
  - Added [PHPCS and PHPCBF](https://github.com/docksal/addons/tree/master/phpcs) addon

### New features

- `fin pull` - New set of commands to interact with hosting providers
- [Pantheon](https://pantheon.io/) stack (#143)
- Windows Subsystem for Linux (WSL) support (Docker Desktop and VirtualBox modes)
  - Versions of Windows prior to Windows 10 are no longer supported
  - Babun (Windows) is deprecated and is no longer supported
  - WSL is now the default and the only supported installation mode on Windows
- Added new services to stacks
  - [Nginx](https://github.com/docksal/service-nginx)
  - [MariaDB](https://github.com/docksal/service-mariadb)
  - [Redis](https://github.com/wodby/redis)
  - [Elasticsearch](https://hub.docker.com/_/elasticsearch)
- Angular boilerplate

### Changes and improvements

- Refactored Docksal install/update mechanism 
- `fin run-cli` switched to `docksal/cli:2.6-php7.2`
- Fixed a regression in upstream DNS detection
- Improved version checking for Docker, Docker Compose, Docker Machine, and Docker Desktop
- Removed deprecated `db` service in `stacks/services.yml`
- Refactored version pinning with Docker install script
- Improved mounting of SMB and NFS shared volumes
- Fixed issue with using Drush Launcher and XDebug
- Fixed install process for Drupal 7 Advanced
- Added universal healthcheck waiting for all services during stack startup (#554)
- Added ability to use an alias in a custom command (#974)
- Added `PROJECT_URL` variable and printing it after project start (#716)
- Fixed default ssh key generation when there are no SSH keys on the host
- Switched to using SMB v3.02 to mount shares on Windows
- Deprecated `fin vm start/stop` in favor of `fin system start/stop`
- Deprecated Babun as an installation method on Windows
- Added a global debug mode in `fin` (e.g. `FIN_DEBUG=1 fin <command>`)
- `fin exec` and `fin bash` now use `sh` by default and only use `bash` for `cli` and `db` (#993, #942)
- Refactored Travis tests to run concurrently

### Documentation

- Added [fin pull (hosting integrations)](https://docs.docksal.io/fin/fin-pull/)
- Added [Advanced Use Cases](https://docs.docksal.io/fin/fin-pull/use-cases/) section
- Added a page about the [Boot2Docker update](https://docs.docksal.io/troubleshooting/boot2docker-update/) (breaking change in Docker 18.09)
- Added instructions for [using Xdebug with Visual Studio Code](https://docs.docksal.io/tools/xdebug/#debugging-with-visual-studio-code) (#955)
- Updated [installation instructions](https://docs.docksal.io/getting-started/setup/) (#946, #1006)
- Improved documentation for [Redis](https://docs.docksal.io/tools/redis/) (#923)
- Improved documentation for [shared volumes](https://docs.docksal.io/core/volumes/)
- Improved documentation on [extending Docksal images](https://docs.docksal.io/stack/extend-images/)
- Improved documentation on [switching Docker modes](https://docs.docksal.io/getting-started/docker-modes/)


## 1.11.1 (2018-11-27)

### New software versions

- fin v1.80.1
- Docker Compose v1.23.1

### Changes and improvements

- Docker Compose v1.23.0+ compatibility (#819)
  - Ships with the latest versions of Docker for Mac/Windows (v2.0.0.0) and introduces a breaking change (docker/compose#6316)
- Fixed getting the list of Docksal project images to update (#839)
- Make SMB share mount more predictable (#842)
- Fixed "fin ssh-key add <key-name>" compatibility with Bash 3 (#857)

### Documentation

- Restructured and updated stack configuration docs (#847)
- Updated SSH agent docs


## 1.11.0 (2018-11-15)

### New software versions

- fin v1.79.4
- Docker v18.06.1-ce
- VirtualBox v5.2.20
  - macOS Mojave compatibility
  - You may have to run `fin update` twice to get VirtualBox automatically updated (macOS and Windows) (#836)
- System service updates
  - [docksal/dns:1.1](https://github.com/docksal/service-dns/releases/tag/v1.1.0)
    - Switched base image to Alpine 3.8. Overall refactoring.
  - [docksal/ssh-agent:1.2](https://github.com/docksal/service-ssh-agent/releases/tag/v1.2.0)
    - Switched base image to Alpine 3.8. Overall refactoring.
    - `ssh-key` - the SSH key management script used by the new `fin ssh` set of commands
  - [docksal/vhost-proxy:1.4](https://github.com/docksal/service-vhost-proxy/releases/tag/v1.4.0)
    - Switched base image to `openresty/openresty:1.13.6.2-1-alpine` (Alpine 3.8)
    - Added `DEFAULT_CERT` support
- Stack updates
  - [docksal/cli:2.5-php7.1](https://github.com/docksal/service-cli/releases/tag/v2.5.0)
    - Set `max_input_vars` to `2000` for PHP FPM
    - Added APCu pecl extension
    - `SECRET_SSH_PRIVATE_KEY` should now be base64 encoded
    - Refactored Acquia Cloud API authentication
    - and more

### New features

- `fin ssh-key` - new set of commands to manage SSH keys and ssh-agent
- Using SMB 2.1 to mount shares on Windows (#667)
  - You no longer need to enable the legacy SMB 1.0 support on Windows 10!
- `DOCKSAL_VOLUMES=none` option
  - Not mounting the codebase from the host and using an empty volume instead. Provides best fs performance, but the code has to be managed inside the container stack.

### Changes and improvements

- Automatically pass git `user.email` and `user.name` settings from the host to `cli`
- Exit if system services failed to start (#772)
  - This prevents broken system states where one or more Docksal services failed to start without the user being informed of this being the case.
- Properly handle Blackfire secrets in `fin sysinfo` output (#783 #784)
- Added `DEFAULT_CERT` support for `vhost-proxy` via the `DOCKSAL_VHOST_PROXY_DEFAULT_CERT` global variable
- Added `SANDBOX_PERMANENT` configuration variable for sandboxes
- Print vhosts without `http://` in `fin vhosts`
- Drop `cli_home` volume when `cli` service is removed/reset (#787)
- Drop `db_data` volume when `db` service is removed/reset
- Skip loading SSH keys that already exist in the `ssh-agent` (#773, #774)
- Fixed detecting first nameserver in `/etc/resolv.conf` (#782)
- DNS detection should not use localhost IP addresses as upstream DNS (#770)
- Drop project network when stopping a project (#582)
- Fixed running "fin rc" with no arguments
- Use a login bash session in `fin run-cli` and `fin bash` (docksal/service-cli#92)
- Fixed issue related to RC check (#815)
- Fixed `nslookup` probe on Alpine
- Set `SYNC_PREFER=newer` in unison volume settings to prefer most recently updated files (#821)
- Removed the ability for global addons to use `run-cli` because we cannot guarantee that `$HOME/.docksal` directory is mapped inside Docker (#771)
- Updated automated tests

### Documentation

- Migrated docs to Hugo and Netlify
- Docs structure overhaul
- Improved documentation for `fin reset`
- Updated system requirements: Added CPU SSE4.2 instruction set requirements for Linux and how to check whether a CPU supports them. (docksal/service-vhost-proxy#35)
- Updated instructions around PHP/PHP-FPM settings overrides (#608)
- Added docs for `SANDBOX_PERMANENT` and `VIRTUAL_HOST_CERT_NAME`
- Updated "File sharing" (VirtualBox mode)
- Removed Windows 10 SMB1 mentions


## 1.10.1 (2018-08-03)

### New software versions

- fin 1.69.1

### Changes and improvements

- Fixed help for project level and global commands on Linux. Custom commands list did not display on Linux.
- Fixed broken db commands. Some DB commands did not function properly in 1.10.0.

### Documentation

- Fixed path to crontab in cron.md doc
- Updated multiple-projects.md regarding virtual host configuration

## 1.10.0 (2018-07-31)

### New software versions

- fin 1.67.2
- System service updates
  - Switched `vhost-proxy` to [docksal/vhost-proxy:1.3](https://github.com/docksal/service-vhost-proxy/releases/tag/v1.3.0).
    - Added support for custom certs an more
- Stack updates
  - Switched `cli` to [docksal/cli:2.4-php-7.1](https://github.com/docksal/service-cli/releases/tag/v2.4.0).
    - Cloud9 IDE integration
    - Platform.sh CLI
    - Custom startup script support
    - Cron jobs and more

### New Features

- Support for a wide variety of Linux distributions: Debian, Ubuntu, Mint, Fedora, Centos, Alpine (#629)
- Ability to use release candidate release for updates. To use: `fin config set --global DOCKSAL_USE_RC=1` (#719)
- `fin platform` - run Platform.sh cli in `cli`
- `fin composer` - run composer in `cli`
- `fin project erase` command - removes containers and erases project files on the host
- `fin db truncate` - truncate a database (defaults to the `default`)
- `fin init` - a default placeholder command when there is no project level `init` command defined
- `fin config` now accepts the `--env=<environment>` flag, e.g., `fin config set --env=local IDE_ENABLED=1` (#584) 
- `fin exec` now accept the `--in=<service>`, e.g., `fin exec --in=db mysql -uroot -p` flag (#609)
- `fin project create` now accepts `--name`, `--choice` and `--yes` options and can be run unattended 
- `fin share`
  - Ability to set ngrok options via `fin share` arguments (#601)
  - Ability to use ngrok configuration file for `fin share` (#611)
- `exec_target = run-cli` can be used in custom commands and addons to run them in a standalone run-cli session (#715)
- [Drupal 8 Composer](https://github.com/docksal/boilerplate-drupal8-composer) boilerplate project (#174)

### Changes and improvements

- Switched to simplified, non-persistent network configuration on Linux
  - Supporting various Linux flavors (Debian, Ubuntu, Mint, Fedora, Centos) is much simpler now
- Fixed DNS connectivity when external DNS (Google DNS) is not accessible
- Removed `vm` command when running on Linux
- Removed `uuidgen` as a dependency (#630) 
- `fin run-cli` now uses SSH keys from the `ssh-agent` service
- Fixed custom command output ordering in `fin help`
- Fixed `fin share` when no parameters are provided
- Added description for `docker` and `docker-compose` in `fin help`
- Fixed `fin` not correctly waited for unison during `fin up`
- Auto-detect upstream DNS when possible (#663)
- Added custom cert support when starting `vhost-proxy` service
- Fixed an issue when `fin config get/set/rm` did not work with an alias (#670)
- Fixed network setup on Docker for Mac/Win
- Fixed `fin vhosts` spitting out nginx config lines
- Added a named `db_data` volume for MySQL/PostreSQL, so its easier to identify them in the `docker volume ls` list
- Added a named `cli_home` volume for `/home/docker` in `cli`, so its easier to identify them in the `docker volume ls` list
- Prefixed Blackfire secrets with `SECRET_` to hide the keys in `fin config` output
- Switched to using bash login sessions for cli (`bash -l`)
  - `bash -l` sources `~/.profile` inside cli (for both interactive and non-interactive sessions)
- Using custom `docksal/bats` with an interactive tests mode support for automated tests (#705)
- Applying `overrides-osxfs.yml` only for bind volumes (#709)
- Fixed a bug that unison volumes were not deleting host files, which were deleted inside `cli`
- Improved `parse_params` to be more robust when invalid parameters are fed in (#735)
- Fixed `DOCKER_HOST` on WSL
- Increased verbosity of `fin sysinfo`
- `fin diagnose` now includes information from `fin sysinfo` and should be used to provide diagnostic information when submitting issues on Github (#627)
- Fixed VirtualBox does not install on Windows if username has spaces (#636)
- Fixed Windows `CRLF` line endings detection (#639)
- Removed `git` as a dependency in `fin project create` (#635)
- Fixed `fin run-cli` run in `/root` on PWD (#661)
- Fixed `fin exec` behaving differently and failing when passing an existing script as an argument (#720)
- Updated `fin phpcs` sample command to include `DrupalPractice` standard (#724)
- Escaped spaces for params passed to `fin run-cli` to make it behave the same way as `fin exec` (#738)
- Fixed project categorization for Hugo in `fin project create`
- Updated and improved automated tests across different projects (cli, web, fin, etc.)

### Documentation

- New: Setting up Cron jobs in cli (#671)
- New: Using Platform.sh CLI tool
- New: Enabling and using Cloud9 integration (#690)
- Updated: installation docs (#658)
- Updated: README.md in docksal/docksal, removed outdated information
- Updated: Windows troubleshooting: VirtualBox installation fails on Windows (Hyper-V Enabled) (#641)
- Updated: Extending stock Docksal images (#655)
- Updated: Xdebug docs (#734)
- Updated: Switching PHP versions (#744) 


## 1.9.1 (2018-06-07)

### Changes and improvements

- Fixed an error with setting DB privileges during `fin db create`
- Disabled network cleanup in `fin cleanup` (triggered during updates) (#582)
  - Check [this fix](https://github.com/docksal/docksal/issues/582#issuecomment-395537109) if you updated to Docksal 1.9.0 and had your stopped project(s) broken

### Documentation

- Updated 1.9.0 release notes to mention a breaking change in docker-compose 1.21.1
- Fixed typos here and there


## 1.9.0 (2018-06-05)

### New software versions

- fin 1.60.0
- Stack updates
  - Switched `cli` to [docksal/cli:2.2-php-7.1](https://github.com/docksal/service-cli/releases/tag/v2.2.0).
- Docker 18.03.1
- Docker Compose 1.21.1
  - **[BREAKING]** Projects with dashes in names need `fin reset` ([Read more](https://blog.docksal.io/breaking-change-in-docker-compose-1-21-1-c00fda7e1b75))
- VirtualBox 5.2.2

### New Features

- Alpine Linux support.
- [Play-with-Docker](https://labs.play-with-docker.com/) support
  - You can now try and play with Docksal online, free of charge, and within minutes!
- **Experimental**: Cloud9 IDE integration
  - Cloud9 provides an in-browser IDE and terminal for your project and stack.
  - Run `fin config set IDE_ENABLED=1 && fin project reset cli` in your project folder to enable Cloud9 IDE.
  - Open `http://ide.<VIRTUAL_HOST>` 
- `fin config [get|set|remove]`
  - New commands to manage project level (`.docksal/docksal.env`) and global (`$HOME/docksal/docksal.env`) Docksal variables.
  - See `fin help config` for details.
- New boilerplate frameworks:
  - [Symfony Skeleton](https://github.com/docksal/example-symfony-skeleton)
  - [Symfony WebApp](https://github.com/docksal/example-symfony-webapp)
  - [Backdrop CMS](https://github.com/docksal/example-backdrop)

### Changes and improvements

- Improved `fin share` to allow for custom ngrok configuration (see [Additional ngrok configuration](https://docs.docksal.io/en/master/tools/ngrok/#additional-ngrok-configuration)).
- Extended `fin config generate` to allow for `DOCKSAL_STACK` and `DOCROOT` to be set at runtime.
  - See `fin help config` for details.
- `fin run-cli`:
  - Switched default image for `fin run-cli` to use `docksal/cli:2.2-php7.1`.
  - Allow passing environment variables to the `run-cli` container at run time or through `$HOME/.docksal/docksal.env` file.
  - Fixed Windows support.
  - Standard secrets (`SECRET_*` variables) are now passed to the `run-cli` container.
  - Substantially improved startup container time by declaring `/home/docker` as a volume (same as in the default stack).
  - See `fin help run-cli` for more details
  - **[BREAKING]** Persistent `$HOME` directory in the `run-cli` container by default.
  - **[BREAKING]** Image and debug are now options (`--image=...`, `--debug`) 
- Reworked `fin project create` command screen to separate out different frameworks and languages.
- Refactored `fin ssh-add` command to allow for non-standard ssh keys to be add automatically (see [Automatically add keys](https://docs.docksal.io/en/master/advanced/ssh-agent/#automatically-add-keys)).
- Refactored OS detection.
- Fixed `fin help` to reference commands within folders.
- Refactored container remove function.
- Refactored unison volumes integration.
  - Forked our own `docksal/unison` image.
  - **[BREAKING]** renamed `bg-sync` to `unison` in `fin` and in `stacks/volumes-unison.yml`. 
- Fixed `fin stop --all` to stop all Docksal projects not all existing Docker containers.
- Fixed Travis CI to run correctly with external pull requests.
- Improved testing across functionality.
- Fixed issue with `fin db create` failing if database exists and `fin db drop` failing if database did not exist.
- Fixed missing host file on WSL.
- Added `blackfire` service configuration to `services.yml` and updated Blackfire documentation.
- Refactored network configuration on Ubuntu
  - During `fin system stop` network settings introduced by Docksal will now be reverted.
- Fixed (workaround) a Docker bug with long commands overlapping on single terminal line (`fin exec` and `fin run-cli`).
- Add a warning when running `fin` as root.

### Documentation

- New: [Addons](https://docs.docksal.io/en/v1.9.0/fin/addons) - extending projects with extra commands and integrations.
- New: [phpMyAdmin](https://docs.docksal.io/en/v1.9.0/tools/phpmyadmin) integration docs.
- New: [Redis](https://docs.docksal.io/en/v1.9.0/tools/redis) integration docs.
- New: [fin help](https://docs.docksal.io/en/v1.9.0/fin/fin-help) - content from all `fin help` topics.
- New: [fin run-cli](https://docs.docksal.io/en/v1.9.0/fin/fin-run-cli) command docs.
- Updated [Using native Docker applications](https://docs.docksal.io/en/v1.9.0/getting-started/env-setup-native) docs to use the new `fin config set` command.
- Updated [SSH agent](https://docs.docksal.io/en/v1.9.0/advanced/ssh-agent) with a section on how to automatically local non-default keys.
- Updated [Custom commands](https://docs.docksal.io/en/v1.9.0/fin/custom-commands/#grouping-commands) with a section on grouping custom commands.
- Updated [Setup instructions](https://docs.docksal.io/en/v1.9.0/getting-started/setup) with new boilerplate repos.
- Updated [Blackfire](https://docs.docksal.io/en/v1.9.0/tools/blackfire) integration instructions.
- Updated [ngrok](https://docs.docksal.io/en/v1.9.0/tools/ngrok) (`fin share`) integration instructions with the new configuration options.
- Updated [Xdebug](https://docs.docksal.io/en/v1.9.0/tools/xdebug) docs with instructions on using Xdebug with the Atom editor.
- Updated [Extending stock images](https://docs.docksal.io/en/v1.9.0/advanced/extend-images) 
- Updated [Stack configuration](https://docs.docksal.io/en/v1.9.0/advanced/stack-config) docs with all available variables in Docksal.
- Updated [Troubleshooting](https://docs.docksal.io/en/v1.9.0/troubleshooting) with instructions on "Docker unauthorized" issues.
- Fixed typos and grammar found within documentation.


## 1.8.0 (2018-04-05)

### New software versions

- fin 1.52.0
- Stack updates
  - Switched `cli` to [docksal/cli:2.1-php7.1](https://github.com/docksal/service-cli/releases/tag/v2.1.0)
  - Switched `db` to [docksal/db:1.2-mysql-5.6](https://github.com/docksal/service-db/releases/tag/v1.2.0)

### New Features

- Secrets - a way to pass keys/tokens to `cli`
  - Currently supported: `SECRET_SSH_PRIVATE_KEY`, `SECRET_ACAPI_EMAIL`, `SECRET_ACAPI_KEY`, `SECRET_TERMINUS_TOKEN`
  - All secrets should be prefixed with `SECRET_`
  - Secrets are masked in `fin config` output to protect sensitive data
  - Secrets can be set in the global `docksal.env` file (`$HOME/.docksal.env`) or the project one(s)
  - Requires `docksal/cli` [v2.1.0+](https://github.com/docksal/service-cli/releases)
- Terminus integration (#485)
  - Shortcut command for Terminus - `fin terminus`
  - Requires `docksal/cli` [v2.1.0+](https://github.com/docksal/service-cli/releases)
- Added PostgreSQL service definition in `services.yml` (#193)

### Changes and improvements

- Added support to run `fin debug` with project configuration loading
  - `fin debug -c ...`, `fin debug --load-configuration ...`
- Removed an old workaround in `fin drush` and `fin drupal` when run with empty arguments
  - drush used to choke on empty arguments (e.g., drush "")
  - drupal console never needed this workaround
- Allow `fin alias` creation command to also update aliases
  - Added the "-f" option when creating an new alias link. This allow one to use the same command to update aliases vs. the current workflow of first removing the alias then adding it back in with the new path. (#496)
- Updated `fin run-cli` (`fin rc`) to use `docksal/cli:2.1-php7.1` (#483)
- Stacks: renamed `db` to `mysql` in `services.yml`
  - Keeping the old `db` service definition for backward compatibility

### Documentation

- Updated [Drush docs](https://docs.docksal.io/en/v1.8.0/tools/drush)
  - Drush Launcher
  - Site aliases with Drush 9
- New docs for [Acquia Drush Commands](https://docs.docksal.io/en/v1.8.0/tools/acquia-drush) and [Terminus](https://docs.docksal.io/en/v1.8.0/tools/terminus)
- Changed [macOS installation instructions](https://docs.docksal.io/en/v1.8.0/getting-started/env-setup/#macos) to account for VirtualBox installation issues on macOS High Sierra


## 1.7.0 (2018-03-19)

### New software versions

- fin 1.50.3
- Docker Compose 1.19.0
- Docker Machine 1.14.0
- System services
  - `vhost-proxy` upgraded to [v1.2.0](https://github.com/docksal/service-vhost-proxy/releases/tag/v1.2.0)
    - Increased proxy buffers to `256k` - fixes 500 errors for some Drupal 8 sites sending huge HTTP headers
    - routing to a non-standard port
    - HTTP/2 support
- Stacks
  - PHP stacks now use `docksal/cli:2.0-php7.1` (PHP 7.1) by default
    - [v2 cli images](https://blog.docksal.io/new-docksal-cli-images-2-0-fd88243d79b9), built from official Docker PHP-FPM images
  - Acquia stack now uses `1.1-varnish5` (Varnish 5) image

### New Features

- `fin system` subset of commands (#387)
  - `fin system stop` - removes Docksal system services and stops all Docksal projects (`fin stop --all`)
- New `default-nodb` stack - when you don't need MySQL (#427)
- New `node` stack and [sample project](https://github.com/docksal/example-nodejs)
- New project wizards (Grav CMS, Gatsby JS, Laravel, Hugo)

### Changes and improvements

- `fin cleanup` refactoring
  - Use Docker's `prune` commands where it makes sense
- Revised short aliases for miscellaneous commands
  - Only leaving aliases that feel common and would make sense for most people right away
- `fin db create` now uses `utf8mb4`/`utf8mb4_unicode_ci` charset/collation by default (#437)
- Disallowing underscores or uppercase letters in project name (#438)
- `fin config generate` now uses `DOCKSAL_STACK=default` (instead of a full blown `stack-default-static.yml` definition) (#433)
- Removed static stacks (`stack-acquia-static.yml` and `stack-default-static.yml`)
- Fix warning with `fin stop -a` when no projects are running (#450)
- Fix the bug that `fin` was not able to use Unison volumes with Docker for Mac
- Allow using paths relative to the project root in `docksal.yml` (#459)
  - Use `docksal.yml` path to detect docker-compose context directory
  - `docksal.yml` now becomes required, so we create it automatically if it does not exist
  - `docksal.env` is also created automatically (if not present) to have both configs around for users to use
- Fixed error when `DOCKER_RUNNING` was not always exported
- Always use `winpty` on windows (since the experimental Docksal bash shell is deprecated) (#457)
- Removed old `FIN_SET_UID` variables
- Added support for vhost-proxy v1.2  logging options via global `docksal.env`
- Mounting `project_root` in `varnish` and `solr` services  to give access to the project codebase and load custom configuration overrides (see respective docs for details)
- Updated `solr` service
  - Using the new `io.docksal.virtual-port` label supported introduced in `docksal/vhost-proxy:1.2`
  - Solr can now be accessed via vhost-proxy at `http://sorl.<VIRTUAL_HOST>/solr`
- Updated `mailhog` service
  - Using the new `io.docksal.virtual-port` label supported introduced in `docksal/vhost-proxy:1.2`
  - MailHog web UI can now be accessed via vhost-proxy at `http://mail.<VIRTUAL_HOST>`
  - Removed binding to port `80` and thus the `user: root` override (necessary to bind to privileged ports). This is no longer necessary with vhost-proxy v1.2+ supporting custom port routing.
- When `CI=true` is set in in `$HOME/.docksal/docksal.env`, vhost-proxy will be open to the world (bind to `0.0.0.0`). This should be used in CI/Sandbox environments.
- Fixed fin aliases not working on Linux
- Passing `VIRTUAL_HOST` variable to `cli` by default, so that it can be used in scripts that run inside `cli`
- `DOCKER_HOST` can now be overridden via `$HOME/.docksal/docksal.env` (#452)
- Added ability to override the default host value for `fin share` (`fin share --host=example.com`) (#363)
- Removed old tests and updated existing ones

### Documentation

- Document installation issues on a fresh macOS High Sierra (#417)
- Update [PHP settings overrides](https://docs.docksal.io/en/master/advanced/stack-settings) (changed in cli v2.0 images)
- Updated [fin docs](https://docs.docksal.io/en/master/fin/fin)
  - `fin system` subset of commands
- Updated [Varnish](https://docs.docksal.io/en/master/tools/varnish), [Solr](https://docs.docksal.io/en/master/tools/apache-solr), [MailHog](https://docs.docksal.io/en/master/tools/mailhog), [Memcached](https://docs.docksal.io/en/master/tools/memcached) docs
  - Removed advanced usage (custom stack) examples for `memcached` and `varnish` to keep instructions simpler. Using the `extends` approach in yml should be the mainstream.
- Updated [ngrok docs](https://docs.docksal.io/en/master/tools/ngrok)


## 1.6.1 (2017-12-12)

**IMPORTANT NOTE:** if you use VirtualBox you may have to run `fin update` **twice** for this release.

This release addresses a critical issue in 1.6.0, which breaks new Docksal installations on Mac/Windows using 
VirtualBox mode. We are also introducing support for WSL on Windows (in beta).

### New software versions

- fin v1.43.2

### New Features

- Windows: WSL (Windows Subsystem for Linux) support (beta) (#188, #407, #421)
- Docker for Mac, Unison volumes: `fin logs unison` - show Unison log

### Changes and improvements

- Check for `docker-machine` binary existence during vm stop on update (#422)
- Fixed xdebug configuration regression (#420)
- Docker for Mac, Unison volumes: Added ability to wait for the initial sync to complete.
- Added ability to lock Docksal updates

    Set `DOCKSAL_LOCK_UPDATES` to anything in `$HOME/.docksal/docksal.env` to lock updates. Useful on CI/sandbox servers.

### Documentation

- Updated: [xdebug docs](https://docs.docksal.io/en/v1.6.0/tools/xdebug/)
- Updated: Docker for Mac [Unison volumes](https://docs.docksal.io/en/v1.6.1/advanced/volumes/#unison-volumes)


## 1.6.0 (2017-12-08)

**IMPORTANT NOTE:** if you use VirtualBox you may have to run `fin update` **twice** for this release.

### New software versions

- fin v1.41.0
- docker/boot2docker v17.09.0-ce
- docker-compose v1.16.1
- docker-machine v0.13.0
- VirtualBox v5.1.28 (the latest boot2docker is using VirtualBox Guest Additions v5.1.28, so we stick with a matching version here as well)

### New Features

- `fin project` command subset replaces the old `fin start/stop/restart/rm` commands.

    The old commands are still supported to preserve compatibility.

- Docker for Mac: osxfs caching is automatically enabled to improve read performance. (#249, #397)
- Docker for Mac: [Unison file sync](http://docs.docksal.io/en/v1.6.0/advanced/volumes/#unison-volumes) support
- You can add environment dependent ENV and YML files based on `$DOCKSAL_ENVIRONMENT` variable, e.g., `docksal-myenv.yml`,
 that would only apply, if `DOCKSAL_ENVIRONMENT=myenv` (#383, #354). Official documentation is pending.
- New sample project repos and wizards: [Grav](https://github.com/docksal/example-grav), 
[Gatsby JS](https://github.com/docksal/example-gatsby) and [Laravel](https://github.com/docksal/example-laravel)
- New `vhosts` command to show all registered Docksal virtual hosts

### Changes and improvements

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
          ## Project root volume
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

### Documentation

- New: [Unison volumes](https://docs.docksal.io/en/v1.6.0/advanced/volumes/#unison-volumes)
- Updated: [SMB troubleshooting](https://docs.docksal.io/en/v1.6.0/troubleshooting-smb/) - SMBv1 issues on Windows 10 Fall Creators Update 1709
- Updated: Docker for Mac/Windows [file sharing](https://docs.docksal.io/en/v1.6.0/getting-started/env-setup-native/)
- Updated: [Getting a list of Docksal images on Docker Hub](https://docs.docksal.io/en/v1.6.0/advanced/stack-config/#docksal-images-and-versions)
- Updated: Switch to using https://get.docksal.io for installs
- Updated: [Portable installation instructions](https://docs.docksal.io/en/v1.6.0/getting-started/portable/)
  - Added support for Docker for Mac/Windows
  - Organized instructions per OS
- Updated: Improved [custom commands](https://docs.docksal.io/en/v1.6.0/fin/custom-commands/) documentation

## 1.5.1 (2017-09-06)

This is a hotfix release aimed to address sporadic issues with TLS certificates caused by a regression between 
docker-machine 0.12.0 and docker engine 17.06.0.

### New software versions

- docker-machine v0.12.2


## 1.5.0 (2017-08-24)

### New software versions

- fin v1.26.0
- Stack images updates
  - `web`: [docksal/web:2.1-apache2.2](https://github.com/docksal/service-web/releases) and [docksal/web:2.1-apache2.4](https://github.com/docksal/service-web/releases)

### New Features

- `--no-truncate` option for `fin db import`
- `fin db cli` now accepts query as an argument and `--db` parameter to specify the database to run query against
- `fin db create` and `fin db drop` commands
- `fin diagnose` command

### Changes and improvements

- Basic automated test in example repos
- Removed old icon scripts on for Windows
- Made `DOCROOT` variable accessing in `cli`

### Documentation

- New: [Troubleshooting SMB shares creation, mounting and related issues on Windows](http://docs.docksal.io/en/v1.5.0/troubleshooting-smb)
- New: [Web server: Configuration overrides](http://docs.docksal.io/en/v1.5.0/advanced/web-configuration-overrides) 
- Updated: `fin db` docs regarding `--no-truncate`
- Updated: added recommendations for running custom commands in `cli`


## 1.4.0 (2017-08-03)

### Breaking changes

For custom configurations (using `docksal.yml`), if you are getting:

```bash
ERROR: Named volume "host_home:/.home:ro" is used in service "cli" but no declaration was found in the volumes section.
```

Remove `host_home:/.home:ro` from `docksal.yml` and do a `fin project start`.

### New software versions

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

### New Features

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

### Changes and improvements

- The VM on Mac and Windows will now use 2GB of RAM by default
  - Anyone who's low on RAM (< 8GB) can use `fin vm ram 1024` to limit the VM memory to 1GB
- Use `nocopy` mode for `project_root` volume
  - This tells Docker to not merge the content of the volume with the destination directory in the container (if one is not empty)
- SSH Agent usage refactoring
  - Removed dependency on the host's `$HOME` directory mount.
- `host_home` volume is deprecated and removed from stack files
  - **This is a breaking change!**
  - See instructions above on the necessary adjustments to `docksal.yml`. 
- Ability to stop at restart certain service container, e.g., `fin restart db`
- Fix mysql import for large database (#279)
  - Database truncation was rewritten. Now database will be dropped and re-created. Should work faster and more reliable.
- Mysql import and dump functions will properly read `MYSQL_DATABASE` environment variable (#276)
- Temporary workaround for NFS issues on Mac (#265)
- Fixed the install/update process handling when Docker is already installed (#298)
- Other fixes and improvements 

### Documentation

- New: [Extending stock images](http://docs.docksal.io/en/v1.4.0/advanced/extend-images)
- New: [Folder aliases](http://docs.docksal.io/en/v1.4.0/advanced/folder-aliases)
- New: [File sharing](http://docs.docksal.io/en/v1.4.0/advanced/file-sharing)
- Updated: Docker for Mac, Solr, Memcached, Behat and Blackfire docs
- Updated: Troubleshooting with mysql memory edge case


## 1.3.1 (2017-06-02)

### New software versions 
* **fin 1.10.0**

### Fixes and improvements

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


## 1.3.0 (2017-05-16)

### New Features

* `*.docksal` domain resolver now works on Windows removing the need to edit the `hosts` file! 
* `fin db <command>` replaces all previously existing mysql related commands (`sqli` is now `db import` etc.). See `fin db help` for details. Old commands still work for compatibility.
* `fin vm hdd` - show VM hdd capacity and usage. `fin vm stats` will only show CPU and network stats now
* `fin hosts` - easily add or remove a host to/from OS-dependent `hosts` file (Relates to #113)
* Override VirtualBox HDD size during VM creation. Set `VBOX_HDD` environment variable to the desired size in megabytes. Default is `50000`. (see https://github.com/docksal/docksal/commit/d50e00367514f64ad0ae4421f6d08cc614d39e2e for details)

### Changes and improvements

* Windows SMB share creation and mount refactoring
    - Prefix Docksal SMB shares with `docksal-` to avoid conflicts with existing shares. Docksal share names on Windows will now look like `\\computer\docksal-c` instead of `\\computer\c` before. Should address file permissions issues some Windows users had had.
    - Domain name is now properly passed during shares mount. Should address share mount issues for domain users.
    - Mount SMB shares with `ntlmssp` or `ntlm` security options. Perform two attempts: use `ntlmssp` by default, use `ntlm` as a fallback. Should address issues for many users of corporate Windows laptops (#117)
    - Perform umount before mount in `smb_share_mount` to simplify debugging (e.g., `fin vm mount` to remount the share)
    - Allow overriding CIFS `sec` option by setting `SEC_SMB` environment variable. Useful for debugging or for edge cases when neither of existing options work. `SMB_SEC=ntlmv2 fin vm mount`. Also see [unix.stackexchange.com/questions/124342](https://unix.stackexchange.com/questions/124342/mount-error-13-permission-denied/124352#124352)
* Improve messaging to show when database dump is being imported from stdin 
* Fix automatic VirtualBox installation on Windows
* Docksal console desktop icon is deprecated. With the winpty improvements there is no need in this experimental console approach anymore.
* Import SSH keys during containers reset on Linux (#180)
* `vhost-proxy` and `dns` are now binding to `192.168.64.100` on all platforms. This should help to avoid conflicts with local web server instances (assuming they also don't bind to `0.0.0.0`, but use a specific IP instead (e.g., Apache on Linux can now run on `127.0.0.1` in parallel with Docksal)

### Documentation

* How to increase Docksal VirtualBox VM disk size 
* Drush site aliases documentation improvements
* New edge case in Troubleshooting: `FastCGI: incomplete headers`
* Updated "Working with multiple projects/domains"
* Added "Stats and analytics" section


### 1.2.0 (2017-04-12)

#### New features

- New one-line installer: `curl -fsSL get.docksal.io | sh`
- Docksal usage stats. Minimal OS/version and fin version tracking via Google Analytics.
- `fin debug` - a new hidden command for debugging purposes
- `fin exec` can now take a file as an argument and will execute it inside cli (e.g., `fin exec script.sh`)
- `fin vm mount` - a new hidden command to attempt re-mounting of shares on Mac and Windows.
- `fin project create` - replaces `fin create-site`
- `fin run-cli` - run a standalone, one-off cli container in the current directory. This allows using any tool inside cli without an already created/running Docksal project/stack.
- `fin image` command to manage images (save, load, view Docksal images on Docker Hub).
  - Adds support for saving and loading Docksal system and project images (e.g., from a local drive).
- Portable installation mode support (e.g., from a USB drive or a local folder)
  - Useful for conferences/trainings/etc. where internet bandwidth is an issue
  - `fin update` - supports VirtualBox, boot2docker.iso and tools (Mac and Windows)
  - `fin vm start` - load system images from a local `docksal-system-images.tar` file
- Magento support and [sample project repos](https://github.com/docksal/magento)

#### Changes and improvements

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
- Allowing non-tty installation on Mac and Linux (e.g., when used in CI/scripts)
- Miscellaneous other small fixes and improvements

#### Documentation

- MySQL DB access for external tools
- Overriding the default domain name and Using arbitrary custom domains
- Web server logs, HTTP Basic Authentication
- Docksal setup instructions
- fin cli
- Troubleshooting
- Installing Docksal from a USB drive ("portable" mode) 
- Added Github issue and pull request templates


### 1.1.0 (2017-03-07)

#### New features

- Global docksal.env
- Ability to skip VBox version check via `SKIP_VBOX_VERSION_CHECK=1` (add to `~/.docksal/docksal.env`)
- Wildcard virtual host support is on by default (i.e. )
- Added checks for the uniqueness of the project name and virtual host
- Added Magento sample project repo to `fin create-site`

#### Changes and improvements

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

#### Documentation

- Restructured docs
- Updated Xdebug documentation for drush debugging
- Added instructions on using Xdebug with NetBeans
- Added Drupal Console and Drush setup instructions


### 1.0.0 (2017-01-27)

First release.

**IMPORTANT:** Anyone switching from Drude please follow the [update steps](/docs/update-dde.md) precisely to avoid conflicts and issues.


### 1.0.0-rc2 (2017-01-20)

First release.

**IMPORTANT:** Anyone switching from Drude please follow the [update steps](/docs/update-dde.md) precisely to avoid conflicts and issues.


### 1.0.0-rc1 (2016-11-23)

First release.

**IMPORTANT:** Anyone switching from Drude please follow the [update steps](docs/update-dde.md) precisely to avoid conflicts and issues.
