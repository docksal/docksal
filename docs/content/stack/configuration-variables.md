---
title: "Configuration Variables"
weight: 5
aliases:
  - /en/master/advanced/stack-config/
---

Configuration variables can be specified in the `docksal.env` file or by running the `fin config set` command.

There are 2 scopes of variables: global and project. Global scope variables are set in `$HOME/.docksal/docksal.env`, 
while project scope variables are set in `$PROJECT_ROOT/.docksal/docksal.env`. 

```
# Setting a global scope variable
$ fin config set --global DOCKER_NATIVE=1
Added value for DOCKER_NATIVE into /Users/user/.docksal/docksal.env

# Setting a project scope variable
$ fin config set DOCROOT=web
Added value for DOCROOT into /Users/user/Projects/project/.docksal/docksal.env
```


## Global Variables

Changing the default value of a global variable may or may not require additional steps to apply the changes.

### DEFAULT_MACHINE_VBOX_RAM

`Default: 2048`

The default amount of memory allocated to Docksal's VirtualBox machine, in megabytes.

### DEFAULT_MACHINE_VBOX_HDD

`Default: 50000`

The default amount of disk space allocated to Docksal's VirtualBox machine, in megabytes.

### DOCKER_NATIVE

`Default: 0`

Applicable to macOS or Windows.  
Designates whether to run Docker through VirtualBox or Docker Desktop.

For VirtualBox set to `0`. For Docker Desktop set to `1`.

See [Docker Modes](/use-cases/docker-modes) for detailed instructions on this variable usage.

### DOCKER_VERSION_ALERT_SUPPRESS

`Default: 0`

Set to `1` to suppress alerts about the outdated Docksal version.

### DOCKSAL_CONFIRM_YES (global or project)

`Default: 0`

If set to `1`, all yes/no confirms will automatically be answered yes. 
Useful for CI environments that fake tty and thus "freeze" waiting for user input.

### DOCKSAL_CONTAINER_LOG_MAX_FILE

`Default: 10`

The number of docker log files that should be kept before they are removed.

### DOCKSAL_CONTAINER_LOG_MAX_SIZE

`Default: 1m`

The size of the docker logs before they are rotated.

### DOCKSAL_CONTAINER_HEALTHCHECK_INTERVAL

`Default: 10s`

Can be used to increase container healthcheck interval and thus help with excessive load produced by healthchecks from 
many concurrently running containers.

### DOCKSAL_DNS_DOMAIN

`Default: docksal`

This is the domain name used for Docksal project URLs, i.e., `http://$PROJECT_NAME.$DOCKSAL_DNS_DOMAIN`. 
Project named `myproject` will result in `http://myproject.docksal` URL by default.

### DOCKSAL_DNS_IP

Can be used to override IP binding for the docksal-dns system service (Linux only).

This is automatically set to `0.0.0.0` (meaning "listen on all network interfaces") for:

- all virtualized environments (all macOS and Windows installation modes)

### DOCKSAL_DNS_UPSTREAM

`Default: autodetected with fallback to 8.8.8.8`

Override the default DNS server that Docksal uses. For environments where access to Google DNS server (`8.8.8.8`) 
is blocked, it should be set to the LAN DNS server. This is often true for VPN users or users behind a corporate firewall.

### DOCKSAL_NO_DNS_RESOLVER

`Default: 0`

Set to `1` and run `fin system reset` to disable the DNS resolver configuration.

This can be used if there are issues with DNS resolution on the host machine while running Docksal.

Also check `DOCKSAL_DNS_DISABLED` as it may be a better option than just disabling the host resolver configuration.

### DOCKSAL_DNS_DISABLED

`Default: 0`

Set to `1` and do `fin system reset` to disable the `docksal-dns` built-in service and switch to using the public 
`.docksal.site` base domain. This automatically sets `DOCKSAL_DNS_DOMAIN=docksal.site` and  `DOCKSAL_NO_DNS_RESOLVER=1`.

Useful when `docksal-dns` is conflicting with corporate rules or if some other software restricts it 
(`0.0.0.0:53: bind: address already in use`). 

Projects that do not override the `VIRTUAL_HOST` variable will switch to the new `docksal.site` base domain after running 
`fin project restart`. Projects that hardcode `VIRTUAL_HOST` will either need to update the value 
(e.g., `VIRTUAL_HOST=myproject.docksal.site`) or use [fin hosts](/fin/fin-help/#hosts) command to manage host records. 
semi-automatic mode.

### DOCKSAL_HEALTHCHECK_TIMEOUT

`Default: 60`

How many seconds to give project containers to reach `healthy` state before `fin` considers the stack startup as failed. 
The value should be a multiple of `5`.

### DOCKSAL_HOST

`Default: "<unset>"`

If set, overrides the internal `DOCKER_HOST` variable used by Docker / Docker Compose.

This allows pointing Docker client to a different/external Docker host and can be useful in CI scenarios.

Note: Consider using [Docker Contexts](https://docs.docker.com/engine/context/working-with-contexts/) instead.

### DOCKSAL_LOCK_UPDATES

`Default: 0`

When set to `1`, this will prevent Docksal from installing and checking for updates. 
This is usually good in combination with `CI=true`.

### DOCKSAL_NFS_PATH

`Default: /Users`

**macOS only.**  
Sets the location of the folder on the host machine to mount to VirtualBox or Docker Desktop with NFS. 
See [file sharing](/core/file-sharing/) for more information.

### DOCKSAL_SSH_AGENT_USE_HOST

Defaults to `0` for non-CI environments and to `1` for CI environments.

When set to `1`, project's stack will prefer the host's SSH agent (`SSH_AUTH_SOCK` socket) over the built-in docksal-ssh-agent.
Can be used in conjunction with [SSH agent forwarding](https://developer.github.com/v3/guides/using-ssh-agent-forwarding/).

**Warning**: on Mac and Windows, this will open up an SSH proxy over TCP listening on the internal `DOCKSAL_HOST_IP` address.
Other users on your system are able to connect to this address and use your SSH agent.

### DOCKSAL_SSH_PROXY_PORT

Default: `30001`

The TCP port to use to listen on `DOCKSAL_HOST_IP` when proxying SSH authentication to an agent running on the host. 
Only used on Mac and Windows if `DOCKSAL_SSH_AGENT_USE_HOST` is set to `1`.

### DOCKSAL_STATS_OPTOUT

`Default: 0` 

When set to `1`, `fin` will not send [minimal statistic information](/core/analytics).

### DOCKSAL_USE_RC

When set to `1`, `fin` will check for the availability of release candidate versions. If the newest version available
is a release candidate, it will be download when you run `fin update`.

```
fin config set --global DOCKSAL_USE_RC=1
```

### DOCKSAL_VERSION

`Default: master`

Allows for overriding the Docksal version used for checking for updates. Can be used to pin Docksal version.

Install or update to a specific version:
```
DOCKSAL_VERSION=v1.15.0 bash <(curl -fsSL https://get.docksal.io)
```
Switch to a specific version (after Docksal is installed)
```
DOCKSAL_VERSION=v1.15.0 fin update
```
Pin a specific version for good (no updates)
```
fin config set --global DOCKSAL_VERSION=v1.15.0
```

### DOCKSAL_VHOST_PROXY_IP

Can be used to override IP binding for the docksal-vhost-proxy system service (Linux only).

This is automatically set to `0.0.0.0` (meaning "listen on all network interfaces") for:

- all virtualized environments (all macOS and Windows installation modes)
- CI environments (`CI` variable is set to `true`)

### GIT_USER_EMAIL (global or project)

Overrides git `user.email` inside cli. This is picked up from host's git settings by default (`docksal/cli` v2.5+).

### GIT_USER_NAME (global or project)

Overrides git `user.name` inside cli. This is picked up from host's git settings by default (`docksal/cli` v2.5+).

### HOST_GID

Group ID for the Container User. On MacOS & Linux defaults to current group account `id -g`.

**WARNING: do not override this variable unless you know what you are doing.**

### HOST_UID

User ID for the Container User. On MacOS & Linux defaults to current user account `id -u`.

**WARNING: do not override this variable unless you know what you are doing.**

### IMAGE_DNS

Docker image to use for [dns service](/core/system-dns).

### IMAGE_SSH_AGENT

Docker image to use for [ssh-agent service](/core/system-ssh-agent).

### IMAGE_VHOST_PROXY

Docker image to use as the [vhost-proxy service](/core/system-vhost-proxy).

### SECRET_ACQUIA_CLI_SECRET (global or project)

Acquia CLI Secret. See [Acquia CLI](/tools/acquia-cli/).

### SECRET_ACAPI_KEY (global or project)

Acquia CLI Key. See [Acquia CLI](/tools/acquia-cli/).

### SECRET_SSH_PRIVATE_KEY

Use to pass an additional private SSH key. The key is stored in `/home/docker/.ssh/id_rsa` inside `cli` and will be considered by the SSH client in addition to the keys loaded in `docksal-ssh-agent` when establishing a SSH connection from within `cli`.

### SECRET_TERMINUS_TOKEN (global or project)

Token used for logging in to Pantheon's CLI Tool [Terminus](/tools/terminus/).


## Project Variables

### APACHE_BASIC_AUTH_USER

Username to use for basic authentication.

### APACHE_BASIC_AUTH_PASS

Password to use for basic authentication.

### DOCKSAL_ENVIRONMENT

`Default: local`

Allow for environment specific YML and ENV files. `fin` will load additional configuration from 
`docksal-${DOCKSAL_ENVIRONMENT}.yml` and `docksal-${DOCKSAL_ENVIRONMENT}.env`. 

Default usage is creating `docksal-local.yml` and/or `docksal-local.env` for local overrides that are not intended 
to be committed.

In CI, you might set the value via `export DOCKSAL_ENVIRONMENT=ci` in your build script or globally for all projects 
on a build/sandbox server via `fin config set --global DOCKSAL_ENVIRONMENT=ci`. `fin` will then load
`docksal-ci.env` and/or `docksal-ci.yml` (these you do commit) on top of the default configuration files.

Note: `DOCKSAL_ENVIRONMENT` should not be set and will not work in the project's `docksal.env` file (this is by design).

### DOCROOT

`Default: docroot`

Defines a relative path to the Document Root of the web server. Final path will be `/var/www/$DOCROOT`, so by default it is `/var/www/docroot`. Change it to the desired directory (like `http`) or sub-directory as needed, or set to `.` to use the project root as web server Document Root.

### HOSTING_ENV

This variable is part of the hosting integration variable set. Use the environment designation of your hosting provider,
e.g., `prod`, `test`, `dev`. WordPress is the only provider that doesn't need this. This variable can be overridden by 
using the `--hosting-env` parameter in the `fin pull` command.

### HOSTING_PLATFORM

This variable is part of the hosting integration variable set. Use the platform hosting provider associated with your
project `acquia`, `pantheon`, `platform.sh`, or set it to `drush` or `wp`. This variable can be overridden by using the
`--hosting-platform` parameter in the `fin pull` command.

### HOSTING_SITE

This variable is part of the hosting integration variable set. Use the site id given by your hosting provider. This 
variable can be overridden by using the `--hosting-env` parameter in the `fin pull` command.

### MYSQL_ALLOW_EMPTY_PASSWORD

This is an optional variable. Set to `yes` to allow the container to be started with a blank password for the root user. NOTE: Setting this variable to `yes` is not recommended unless you really know what you are doing, since this will leave your MySQL instance completely unprotected, allowing anyone to gain complete superuser access.

### MYSQL_DATABASE

`Default:  default`

This variable allows you to specify the name of a database to be created on image startup. If a user name and a password are supplied with MYSQL_USER and MYSQL_PASSWORD, the user is created and granted superuser access to this database (corresponding to GRANT ALL). The specified database is created by a CREATE DATABASE IF NOT EXIST statement, so that the variable has no effect if the database already exists.

### MYSQL_INITDB_SKIP_TZINFO

Skip Timezone Checking when initializing the the DB engine.

### MYSQL_ONETIME_PASSWORD

`Default: true`

When the variable is true (unless MYSQL_ROOT_PASSWORD is set or MYSQL_ALLOW_EMPTY_PASSWORD is set to true), the root user's password is set as expired and must be changed before MySQL can be used normally. This variable is only supported for MySQL 5.6 and later.

### MYSQL_PASSWORD

`Default:  user`

This is used to set the newly created user's password.

### MYSQL_PORT_MAPPING

`Default: 3306`

The port mapping to use for MySQL container, e.g., `33061:3306` will expose `3306` port as `33061` on the host. 

### MYSQL_RANDOM_ROOT_PASSWORD

This is an optional variable. Set to `yes` to generate a random initial password for the root user (using pwgen). The generated root password will be printed to stdout (GENERATED ROOT PASSWORD: .....).

### MYSQL_ROOT_PASSWORD

`Default: root`

This variable is mandatory and specifies the password that will be set for the MySQL root superuser account.

### MYSQL_USER

`Default: user`

This is used to create a user, and the user is granted superuser permissions for the database specified by the `MYSQL_DATABASE` variable. Both `MYSQL_USER` and `MYSQL_PASSWORD` are required for a user to be created; if any of the two variables is not set, the other is ignored.

### PGSQL_PORT_MAPPING

`Default: 5432`

The port to use when setting up PostgreSQL.


### POSTGRES_DB

`Default: user`

This variable allows you to specify the name of a database to be created on image startup.

### POSTGRES_PASSWORD

`Default: user`

This is used to set the newly created user's password.

### POSTGRES_USER

`Default: user`

This is used to create a user, and the user is granted superuser permissions for the database specified by the `POSTGRES_DB` variable.

### XDEBUG_ENABLED

`Default: 0`

Enables PHP XDebug Service for debugging. See [XDebug](/tools/xdebug/).

### XHPROF_ENABLED

`Default: 0`

Enables PHP Xhprof Service for debugging. See [Xhprof](/tools/xhprof/).

### XHPROF_OUTPUT_DIR

`Default: /tmp/xhprof`

Location where the Xhprof output should be sent to.

## Image Variables (project)

The following variables are used to set images to a specified version. Using them will prevent the images from being udpated
when Docksal is updated.

### DB_IMAGE

Defaults to the current db image with the default MySQL version defined in `~/.docksal/stacks/services.yml`. 
[See usage](/service/db/settings)

### CLI_IMAGE

Defaults to the current cli image with the default PHP version defined in `~/.docksal/stacks/services.yml`. 
[See usage](/service/cli/settings)

### WEB_IMAGE

Defaults to the current web image with the default Apache version defined in `~/.docksal/stacks/services.yml`. 
[See usage](/service/web/settings)


## CI Variables (global)

The following variables are generally only used within a CI system.

### CI

Only use on Linux servers. 

When set, enables CI mode:

- Sets `DOCKSAL_VHOST_PROXY_IP=0.0.0.0`, which opens vhost-proxy to the world.
- Reports the instance as a CI instance (vs local), so our anonymous usage stats are not skewed.
- Sets `DOCKSAL_SSH_AGENT_USE_HOST=1`, which enables reuse of the hosts `SSH_AUTH_SOCK` socket (Linux only).

This should be used on sandbox servers (and in CI) at the time of Docksal installation like this:

```
curl -fsSL https://get.docksal.io | CI=1 bash
```

### PROJECTS_ROOT

Sets path to the Projects directory on the server. Used in conjunction with `PROJECT_DANGLING_TIMEOUT`.

### PROJECT_DANGLING_TIMEOUT

Defines the timeout of inactivity after which the project stack and code base will be entirely wiped out from the host 
(e.g., 168h). This requires `PROJECTS_ROOT` to be set.

**WARNING: use at your own risk!**

### PROJECT_INACTIVITY_TIMEOUT

Enables the [auto-stop feature](/use-cases/project-auto-start-stop#auto-stop) and defines the period after which a 
project stack is considered inactive and is stopped (e.g., 0.5h).

This feature is disabled by default (set to `0`).

### PROJECT_AUTOSTART

Toggles the [auto-start feature](/use-cases/project-auto-start-stop#auto-start) for projects (automatic start by 
visiting project url).

This feature is disabled by default (set to `0`).

### SANDBOX_PERMANENT

If set to `true`, the sandbox environment will not be removed event after the `PROJECT_DANGLING_TIMEOUT` timeout.

### VIRTUAL_HOST_CERT_NAME

Tells `vhost-proxy` service which cert to use for the project. Certs are expected in `$HOME/.docksal/certs`. 
Project's `VIRTUAL_HOST` setting should match the certificate name.

For `VIRTUAL_HOST=example.com`, the following cert files must be present on the host:

```bash
$HOME/.docksal/certs/example.com.crt
$HOME/.docksal/certs/example.com.key
```

Also see [Default and custom certs for HTTPS](https://github.com/docksal/service-vhost-proxy#default-and-custom-certs-for-https).

For simple locally-trusted HTTPS certs for local development needs see [mkcert integration](/tools/mkcert).
