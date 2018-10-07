---
title: "Stack configuration"
---


It is recommended that you familiarize yourself with the [Docksal stack](../advanced/stack.md) documentation before reading 
this manual. You should understand what project containers are and which project containers exist by default.

**Understanding stack configurations**

1. [Basics](#basics)
2. [Project configuration files](#docksal-yml)
2. [Default stacks](#default-configurations)
3. [Configuration files loading order](#loading-order)

**Using stack configurations**

3. [Zero-configuration](#zero-configuration)
4. [Custom configuration](#custom-configuration)
5. [Don't break your Docksal setup! List of must have values.](#warning)
6. [Checking your configuration](#checking)
1. [Configuration variables](#configuration-variables)

**Docksal images**

1. [Switching PHP version](#php-version)
2. [Switching MySQL version](#mysql-version)
3. [Finding supported PHP/MySQL/etc. versions](#docksal-images)

<a name="basics"></a>
## Basics

Docksal relies on [Docker Compose](https://docs.docker.com/compose/) to launch groups of related containers.
The yml files you use are [Compose Files](https://docs.docker.com/compose/compose-file/). 
Please read the documentation to understand their main sections.

{{% notice warning %}}
Some containers and their parameters are required for Docksal to work properly. 
**Please see [Don't break your Docksal setup!](#warning) section.**
{{% /notice %}}

You have to run `fin project start` (`fin p start` for short) to apply configuration changes.
If you remove services or volumes you have to remove them with `fin project rm [service]`.

## Project configuration files
<a name="docksal-yml"></a>
### docksal.yml

`docksal.yml` is a [Compose file](https://docs.docker.com/compose/compose-file/).
It's the main configuration file for a project and controls its the settings for each service. Use it to
modify settings that are needed for anyone that uses your project.

If you don't have this file in your project folder, fin will load the [default stack](#default-configurations), 
this way providing a zero-configuration setup.

For more details on its role, check [loading order](#loading-order).

<a name="docksal-env"></a>
### docksal.env

`docksal.env` is an [Environment file](https://docs.docker.com/compose/env-file/).

It is used to override of some of the default environment variables, without the need for
a full `docksal.yml` file (e.g., to override `MYSQL_ROOT_PASSWORD`) or to provide additional environment
variables for your automation scripts (see [custom commands](../fin/custom-commands.md)).

<a name="docksal-local"></a>
### docksal-local.yml, docksal-local.env

`docksal-local.yml` and `docksal-local.env` are used for additional customizations that happen after the main files 
are loaded. See [loading order](#loading-order). A good example of their use is [exposing custom ports](../advanced/networking.md#expose-port) 
or switching PHP versions.

These files are intended for local overrides. They should be added to `.gitignore` and never committed into a project 
repo. You can always include an example file in the repo, e.g., `example.docksal-local.env`, and instruct users to copy 
it and adjust as necessary.

<a name="default-configurations"></a>
## Default stacks

Docksal ships with a set of default configurations (stacks), which are `yml` files stored in `$HOME/.docksal/stacks/`.
These files are a good reference when you begin creating a custom project configuration.

| File name                  | Description |
|----------------------------|:------------|
| `volumes-*.yml`            | Different bindings for Docker volumes. The default is `volume-bind.yml`. Always used for binding volumes.  
| `services.yml`             | Contains default service descriptions. Used for zero-configuration. |
| `stack-default.yml`        | The default stack with 3 services that inherits `services.yml`. Used for zero-configuration. |
| `stack-default-static.yml` | Same configuration as `stack-default.yml` but does not inherit `services.yml`|
| `stack-acquia.yml`         | Acquia-like stack with Solr, Varnish and memcached|

!!! warning "DO NOT CHANGE DEFAULT STACKS!"
    Do not change or customize existing default stacks.  
    Use the `.docksal` folder in your project to customize the project configuration.

<a name="loading-order"></a>
## Configuration files loading order

With this swarm of configuration files, Docksal lets you configure a project in a way that works for you and your team. 
Just like Bash configuration files (/etc/profile, bashrc, bash_profile, bash_logout), they give the flexibility to 
configure a Docksal project in dozens of ways.

`fin` loads files in a certain order. Files loaded later override settings from the files loaded earlier. 
The list below goes from the earliest to the latest in this queue.

Loading order:

1. `$HOME/.docksal/stacks/volumes-*.yml` - only `volumes-bind.yml` loads at the moment ([volumes in Docksal](../advanced/volumes.md))
2. `$HOME/.docksal/stacks/stack-*.yml` - only loads if there is no `docksal.yml` in the project or if forced by settings the `DOCKSAL_STACK` variable in `docksal.env`
3. `docksal.yml` - extends the stack if `DOCKSAL_STACK` is set in `docksal.env` or completely overrides it otherwise
4. `docksal.env` - sets or modifies environment variables
5. `docksal-local.yml` - extends the loaded stack or `docksal.yml`
6. `docksal-local.env` - sets or modifies environment variables set previously

To see the files loaded for a particular project run `fin config show`.

<a name="zero-configuration"></a>
## Zero-configuration

You can simply create a `.docksal` folder in your project root and run `fin project start` (`fin start` for short).
The default stack (`$HOME/.docksal/stacks/stack-default.yml`) will be loaded and used to create containers in this case.

This is a great way to start developing a new project. This approach can also be used on a permanent basis, 
if your needs are simple. `stack-default.yml` extends the configuration from `services.yml`, 
so you'll be getting the latest stack versions with every Docksal update.

### Zero-configuration stacks

You can switch between pre-created zero-configuration stacks by adding the following line to your `docksal.env` file 
and running `fin project reset`.

```
DOCKSAL_STACK="acquia"
```

The following stacks are available:

- `default` - web, db, cli (assumed, when none specified)
- `acquia` - web, db, cli, varnish, memcached, solr (used specifically for [Acquia](https://www.acquia.com/) hosted projects)

<a name="custom-configuration"></a>
## Custom configuration

Custom configurations are useful when you have a larger or more complex project. One where a CI server is involved 
or many people are on a project team, and you have to be careful about maintaining software versions. 
Having a custom configuration will protect your project from the updates in `services.yml` when you update Docksal.

```bash
fin config generate
```

This command will create `docksal.yml` by copying `stack-default-static.yml` into the project directory.
This file has a fully independent description of services, so future changes to the default stack(s) will no longer 
affect the project configuration. This also means that future Docksal updates, bringing new features and changes, 
will not automatically apply. You might need to re-generate your static configuration or append those changes manually 
in `docksal.yml`.

<a name="warning"></a>
### Don't break your Docksal setup! List of must have values.


{{% notice warning %}}
Certain configuration settings in yaml files are required for your Docksal stack to function properly.
{{% /notice %}}

#### web

In the `web` service, there are settings defined in the `volumes`, `labels`, `environment`, and `depends_on` sections. 
You should not remove or change these values.

```yaml
  web:
    volumes:
      # Project root volume
      - project_root:/var/www:ro,nocopy
    labels:
      - io.docksal.virtual-host=${VIRTUAL_HOST},*.${VIRTUAL_HOST}
      - io.docksal.project-root=${PROJECT_ROOT}
    environment:
      - APACHE_DOCUMENTROOT=/var/www/${DOCROOT:-docroot}
    # cli has to be up before web
    depends_on:
      - cli
```

#### cli

In the `cli` service, there is the `volumes` section. You should not remove or change these volumes.

```yaml
  cli:
    volumes:
      # Project root volume
      - project_root:/var/www:rw,nocopy
      # Shared ssh-agent socket
      - docksal_ssh_agent:/.ssh-agent:ro
```

<a name="checking"></a>
## Checking project configuration

To review the configuration applied to your project run:

```bash
fin config show
```

It does not show the contents or the configuration files directly. Instead, it compiles them together and outputs 
the resulting configuration. Some important environment variables are listed at the top.  

The `COMPOSE_FILE` section displays files that were used to produce this configuration. 
See [configuration files load order](#loading-order) for more information on how config files are loaded and merged.

A sample output from `fin config show`:

```
COMPOSE_PROJECT_NAME: myproject
COMPOSE_PROJECT_NAME_SAFE: myproject
COMPOSE_FILE:
/Users/testuser/.docksal/stacks/volumes-bind.yml
/Users/testuser/.docksal/stacks/stack-default.yml

PROJECT_ROOT: /Users/testuser/projects/myproject
DOCROOT: docroot
VIRTUAL_HOST: myproject.docksal
VIRTUAL_HOST_ALIASES: *.myproject.docksal
IP: 192.168.64.100

MYSQL_PORT:

Docker Compose configuration
---------------------
networks: {}
services:
  cli:
    hostname: cli
    image: docksal/cli:2.5-php7.1
    volumes:
    - docksal_ssh_agent:/.ssh-agent:ro
    - project_root:/var/www:rw,nocopy
  db:
    environment:
      MYSQL_DATABASE: default
      MYSQL_PASSWORD: user
      MYSQL_ROOT_PASSWORD: root
      MYSQL_USER: user
    hostname: db
    image: docksal/db:1.1-mysql-5.6
  web:
    depends_on:
    - cli
    environment:
      APACHE_DOCUMENTROOT: /var/www/docroot
    hostname: web
    image: docksal/web:2.1-apache2.4
    labels:
      io.docksal.project-root: /Users/testuser/projects/myproject
      io.docksal.virtual-host: myproject.docksal
    volumes:
    - project_root:/var/www:ro,nocopy
version: '2.0'
volumes:
  docksal_ssh_agent:
    external: true
    external_name: docksal_ssh_agent
  project_root:
    driver: local
    driver_opts:
      device: /Users/testuser/projects/myproject
      o: bind
      type: none

---------------------
```

<a name="configuration-variables"></a>
## Configuration Variables

All variables changed below will require, at minimum, a project restart `fin restart` so that they can take effect. Additional steps may be required.

### DOCKSAL_NFS_PATH

The location of the folder on the host machine to mount to VirtualBox. See [file sharing](file-sharing.md) for more information.

### IMAGE_SSH_AGENT

`Default: docksal/ssh-agent:1.0`

The Docker image to use for SSH Agent. This contains the keys that are shared among the projects.

### IMAGE_VHOST_PROXY 

`Default: docksal/vhost-proxy:1.3` 

Docker image to use as the VHOST Proxy. This forwards all requests to the appropriate container based upon the hostname that is being requested.

### IMAGE_DNS

`Default: docksal/dns:1.0`

Docker image to use for DNS Routing.

### DOCKSAL_LOCK_UPDATES 

When set, this will allow for Docksal to no longer accept updates. This is usually good in combination with `CI=true`.

### DOCKSAL_ENVIRONMENT 

`Default: local`

Allow for environment specific YML and ENV files. `fin` will load additional configuration from `docksal-${DOCKSAL_ENVIRONMENT}.yml` and/or `docksal-${DOCKSAL_ENVIRONMENT}.env`. Default usage is creating `docksal-local.yml` and `docksal-local.env` for local overrides that are not intended to be committed.

### DOCKSAL_STATS_OPTOUT 

`Default: 0` 

Allow for collecting of statistical usage of docksal. When set to `1` this will no longer send statistics.

### DOCKER_NATIVE

`Default: 0`

Designates whether to use Docker through VirtualBox or Native Docker. On Linux this is always set to `1`. Otherwise it is set to `0`.

For VirtualBox set to `0`.
For Docker Native set to `1`.

### DOCKSAL_DNS_UPSTREAM

Override the default DNS server that Docksal uses. For environments where access to Google DNS server (`8.8.8.8`) is blocked, it should be set to the LAN DNS server. This is often true for VPN users or users behind a corporate firewall.

### DOCKSAL_VHOST_PROXY_IP

Used to set the IP address for the Docksal reverse proxy to listen on. When `CI` variable is set to `true` this will be set to `0.0.0.0`.

### DOCKSAL_DNS_DOMAIN

`Default: docksal`

This is the domain to use which is tacked on to the end of the projects url.

### DOCKSAL_NO_DNS_RESOLVER

Allow disabling the DNS resolver configuration (in case there are issues with it). Set to `true` to activate.

### MYSQL_ROOT_PASSWORD

`Default: root`

This variable is mandatory and specifies the password that will be set for the MySQL root superuser account.

### MYSQL_ALLOW_EMPTY_PASSWORD

This is an optional variable. Set to `yes` to allow the container to be started with a blank password for the root user. NOTE: Setting this variable to `yes` is not recommended unless you really know what you are doing, since this will leave your MySQL instance completely unprotected, allowing anyone to gain complete superuser access.

### MYSQL_RANDOM_ROOT_PASSWORD

This is an optional variable. Set to `yes` to generate a random initial password for the root user (using pwgen). The generated root password will be printed to stdout (GENERATED ROOT PASSWORD: .....).

### MYSQL_ONETIME_PASSWORD

`Default: true`

When the variable is true (unless MYSQL_ROOT_PASSWORD is set or MYSQL_ALLOW_EMPTY_PASSWORD is set to true), the root user's password is set as expired and must be changed before MySQL can be used normally. This variable is only supported for MySQL 5.6 and later.

### MYSQL_INITDB_SKIP_TZINFO

Skip Timezone Checking when initializing the the DB engine.

### MYSQL_DATABASE

`Default:  default`

This variable allows you to specify the name of a database to be created on image startup. If a user name and a password are supplied with MYSQL_USER and MYSQL_PASSWORD, the user is created and granted superuser access to this database (corresponding to GRANT ALL). The specified database is created by a CREATE DATABASE IF NOT EXIST statement, so that the variable has no effect if the database already exists.

### MYSQL_USER

`Default:  user`

This is used to create a user, and the user is granted superuser permissions for the database specified by the `MYSQL_DATABASE` variable. Both `MYSQL_USER` and `MYSQL_PASSWORD` are required for a user to be created; if any of the two variables is not set, the other is ignored.

### MYSQL_PASSWORD

`Default:  user`

This is used to set the newly created user's password.

### MYSQL_PORT_MAPPING

`Default:  3306`

The port mapping to use for MySQL container, e.g., `33061:3306` will expose `3306` port as `33061` on the host. 

### POSTGRES_DB

`Default:  user`

This variable allows you to specify the name of a database to be created on image startup.

### POSTGRES_USER

`Default:  user`

This is used to create a user, and the user is granted superuser permissions for the database specified by the `POSTGRES_DB` variable.

### POSTGRES_PASSWORD

`Default:  user`

This is used to set the newly created user's password.

### PGSQL_PORT_MAPPING

`Default:  5432`

The port to use when setting up PostgreSQL.

### APACHE_BASIC_AUTH_USER

Username to use for basic authentication.

### APACHE_BASIC_AUTH_PASS

Password to use for basic authentication.

### GIT_USER_EMAIL

Overrides git `user.email` inside cli. This is picked up from host's git settings by default (`docksal/cli` v2.5+).

### GIT_USER_NAME

Overrides git `user.name` inside cli. This is picked up from host's git settings by default (`docksal/cli` v2.5+).

### HOST_UID

User ID for the Container User. On MacOS & Linux defaults to current user account `id -u`.

**WARNING: do not override this variable unless you know what you are doing.**

### HOST_GID

Group ID for the Container User. On MacOS & Linux defaults to current group account `id -g`.

**WARNING: do not override this variable unless you know what you are doing.**

### XDEBUG_ENABLED

`Default:  0`

Enables PHP XDebug Service for debugging. See [XDebug](../tools/xdebug.md).

### SECRET_SSH_PRIVATE_KEY

Use to pass an additional private SSH key. The key is stored in `/home/docker/.ssh/id_rsa` inside `cli` and will be considered by the SSH client in addition to the keys loaded in `docksal-ssh-agent` when establishing a SSH connection from within `cli`.

### SECRET_ACAPI_EMAIL

Acquia Cloud API Email Address. See [Acquia Drush Commands](../tools/acquia-drush.md).

### SECRET_ACAPI_KEY

Acquia Cloud API Key. See [Acquia Drush Commands](../tools/acquia-drush.md).

### SECRET_TERMINUS_TOKEN

Token used for logging in to Pantheon's CLI Tool [Terminus](../tools/terminus.md).

## CI Variables

The following variables should only be used within a CI system. They are primarily used for setting up the ability for Docksal to turn off and conserve resources.

### PROJECT_INACTIVITY_TIMEOUT

Defines the timeout of inactivity after which the project stack will be stopped (e.g., 0.5h).

### PROJECT_DANGLING_TIMEOUT

Defines the timeout of inactivity after which the project stack and code base will be entirely wiped out from the host (e.g., 168h). This requires PROJECTS_ROOT to be set.

**WARNING: use at your own risk!**

### PROJECTS_ROOT

Contains path to the project root directory.

<a name="php-version"></a>
## Switching PHP versions

The PHP version is defined by the `cli` service. The default image used is `docksal/cli:2.5-php7.1`, which uses PHP 7.1.

A service image name consists of two parts: a docker image name and a tag.
`docksal/cli` is the name of the docker image, while `2.4-php7.1` is the image tag.

To switch PHP versions you have to change the image used for the `cli` service to your desired one.  

Note: if the project stack is already running, then apply the changes with `fin project reset cli`. This will properly
reset and update the `cli` service.

[How to find out all supported PHP versions?](#docksal-images)

### Extend or modify config with `docksal-local.yml` or `docksal.yml`

When using zero-configuration (or any other), the service image can be overridden in `docksal-local.yml`.

The same technique is **applicable to `docksal.yml` if `DOCKSAL_STACK` is set in `docksal.env`**. In this case,
`docksal.yml` will extend/modify the stack configuration defined in `DOCKSAL_STACK` instead of overriding it.

To switch the PHP version override the `image` value for the `cli` service.

For example, in `docksal-local.yml` or `docksal.yml`:

```yaml
version: "2.1"

services:
  cli:
    image: docksal/cli:2.5-php7.2
```

`docksal-local.yml` will append or modify the configuration that was loaded before it, regardless of whether it was 
`stack-default.yml` or `docksal.yml`.

`docksal.yml` will append or modify the configuration only if `DOCKSAL_STACK` is set in `docksal.env`.

### Override config with `docksal.yml`

When not using a predefined stack (`docksal.yml` is present and `DOCKSAL_STACK` is not set in `docksal.env`), 
you are in control of everything. In this case the stack configuration is not inherited from 
`services.yml` (`$HOME/.docksal/services.yml`), so you must fully describe the `cli` service in the project's `docksal.yml`.

An example section of a `docksal.yml` file that describes the `cli` service and overrides the PHP version:

```yaml
services:
  cli:
    hostname: cli
    image: docksal/cli:2.5-php7.2
    volumes:
    - docksal_ssh_agent:/.ssh-agent:ro
    - project_root:/var/www:rw,nocopy
```

Note: when not using a predefined stack, you must fully describe all other services (`web`, `db`, etc.) as well.

<a name="mysql-version"></a>
## Switching MySQL versions

Switching MySQL versions is performed in the same way as the PHP version switch. 
Instead of the `cli` service image you will be modifying the `db` service image.

<a name="docksal-images"></a>
## Docksal images and versions

To see all Docker Hub images produced and supported by Docksal team run:

```bash
fin image registry
```

To get all tags of a certain image provide its name with the same command. For example:

```bash
fin image registry docksal/db
```

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](../fin/custom-commands.md) (e.g., `fin init`, which will call `.docksal/commands/init`). Put project specific initialization tasks there, like:

- initialize the Docksal configuration
- import databases or perform a site install
- compile SASS
- run DB updates, special commands, etc.
- run Behat tests

For a working example of a Docksal powered project with `fin init` take a look at:

- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)
- [WordPress sample project](https://github.com/docksal/wordpress)
