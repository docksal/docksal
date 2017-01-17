# Customizing project configurations

It is recommended you read the [Docksal Stack](docksal-stack.md) explanation before reading this manual.
You should understand what project containers are and which project containers exist by default.

**Understanding configurations**

1. [Basics](#basics)
2. [Project configuration files](#docksal-yml)
2. [Default stacks](#default-configurations)
3. [Configuration files loading order](#loading-order)

**Using configurations**

3. [Zero-configuration](#zero-configuration)
4. [Custom configuration](#custom-configuration)
5. [Don't break your Docksal setup! List of must have values.](#warning)
6. [Checking your configuration](#checking)

**Docksal Images**

1. [Switching PHP version](#php-version)
2. [Switching MySQL version](#mysql-version)
3. [Finding supported PHP/MySQL/etc. versions](#docksal-images)

<a name="basics"></a>
### Basics

Docksal relies on [Docker Compose](https://docs.docker.com/compose/) to launch groups of related containers.
The yml files you use are [Compose Files](https://docs.docker.com/compose/compose-file/). Please read the documentation to understand their main sections.

!!! danger "REMEMBER DOCKSAL REQUIREMENTS"
    Some containers and their parameters are required for Docksal to work properly. **Please see [Don't break your Docksal setup!](#warning) section.**

You need to run `fin start` to apply configuration changes. If you remove services or volumes you need to remove them with `fin rm [service]`.

## Project configuration files
<a name="docksal-yml"></a>
### docksal.yml

`docksal.yml` is a [Compose file](https://docs.docker.com/compose/compose-file/).
It's the main configuration file for a project and controls its the settings for each service. Use it to
modify settings that are needed for anyone that uses your project.

If you don't have this file in your project folder, fin will load a [default stack](#default-configurations) providing a zero-configuration setup.

For more details on its role check [loading order](#loading-order).

<a name="docksal-env"></a>
### docksal.env

`docksal.env` is an [Environment file](https://docs.docker.com/compose/env-file/).

It is used to override of some of the default environment variables, without the need for
a full `docksal.yml` file (for example, to override `MYSQL_ROOT_PASSWORD`) or to provide additional environment
variables for your automation scripts (see [custom commands](custom-commands.md).)

<a name="docksal-local"></a>
### docksal-local.yml, docksal-local.env

`docksal-local.yml` and `docksal-local.env` are used for additional customizations that happen after the main files are loaded. See [loading order](#loading-order).
A good example of their use is [exposing custom port](expose-port.md) or switching PHP versions.

<a name="default-configurations"></a>
## Default stacks

Docksal ships with a set of default configurations (stacks), that are yml files stored in `~/.docksal/stacks/`.
These files are a good starting point of reference when you begin creating your own project configuration.

!!! warning "DO NOT CHANGE DEFAULT STACKS!"
    You should not change or customize existing default stacks. You should use `.docksal` folder in your project to customize your project configuration.

| File name                  | Description |
|----------------------------|:------------|
| `volumes-*.yml`            | Different bindings for Docker volumes. The default is `volume-bind.yml`. Always used for binding volumes.  
| `services.yml`             | Contains default service descriptions. Used for zero-configuration. |
| `stack-default.yml`        | The default stack with 3 services that inherits `services.yml`. Used for zero-configuration. |
| `stack-default-static.yml` | Same configuration as `stack-default.yml` but does not inherit `services.yml`|
| `stack-acquia.yml`         | Acquia-like stack with Solr, Varnish and memcached|

<a name="loading-order"></a>
## Configuration files loading order

This swarm of configuration files that Docksal can use provides flexibility to set up your
project in a way that works for your team's needs. Just like Bash configuration files
(/etc/profile, bashrc, bash_profile, bash_logout), they provide flexibility to configure a Docksal
project in dozens of ways.

`fin` loads files in a certain order. Configuration files, that are loaded later, override settings
from files that loaded earlier. The list below goes from earliest to latest in this queue.

You can always see files that were loaded for a project by running `fin config show`.

Loading order:

1. `~/.docksal/stacks/volumes-*.yml` - only `volumes-bind.yml` loads at the moment ([volumes in Docksal](/docksal-volumes.md).)
2. `~/.docksal/stacks/stack-*.yml` - only loads if there is no `docksal.yml` or if forced by `DOCKSAL_STACK` variable in `docksal.env`.
3. `docksal.yml` - extends the stack if `DOCKSAL_STACK` is set in `docksal.env` or completely overrides it otherwise.
4. `docksal.env` - sets or modifies environment variables.
5. `docksal-local.yml` - extends the loaded stack or `docksal.yml`.
6. `docksal-local.env` - sets or modifies environment variables set previously.


<a name="zero-configuration"></a>
## Zero-configuration

You can simply create a `.docksal` folder in your project root and run `fin start`.
`stack-default.yml` will be loaded and used to create containers in this case.

This is a great way to start developing a new project or it can be used all the time
if your needs are simple. `stack-default.yml` inherits `services.yml` so
you'll get latest versions of containers.

### Zero-configuration stacks

You can switch between pre-created zero-configuration stacks by adding the following line to your `docksal.env` file and running `fin reset`.

```
DOCKSAL_STACK="acquia"
```

The following stacks are present:

- `default` - web, db, cli (assumed, when none specified.)
- `acquia` - web, db, cli, varnish, memcached, solr (used specifically for [Acqui](https://www.acquia.com/) hosted projects.)

<a name="custom-configuration"></a>
## Custom configuration

Custom configurations are useful when you have a larger or more complex project. One where a CI server is involved
 or many people are on a project team, and you need to be careful about maintaining software versions. Having a custom configuration
 will protect your project from future `services.yml` updates when you update Docksal.

```bash
fin config generate
```

This command will create `docksal.yml` by copying `stack-default-static.yml` to your project directory.
This file has fully independent descriptions of services, so future changes to `services.yml` will no longer affect your project-specific configuration.

This also means if future Docksal updates bring new features and changes to `services.yml`, you might need to re-generate your static configuration or append those changes manually to your `docksal.yml`.

<a name="warning"></a>
### Don't break your Docksal setup! List of must have values.

!!! important "REQUIREMENTS"
    Some must have values for your Docksal stack to work properly.

There are some values that are not required for docker-compose to work but are required for your Docksal stack to function.

**1.** In the `web` service there are a volumes, labels, environment variables and a dependency. You should not remove or change these values.

```yaml
  web:
    volumes:
      # Project root volume
      - project_root:/var/www:ro
    labels:
      - io.docksal.virtual-host=${VIRTUAL_HOST}
      - io.docksal.project-root=${PROJECT_ROOT}
    environment:
      - APACHE_DOCUMENTROOT=/var/www/${DOCROOT:-docroot}
      - VIRTUAL_HOST=${VIRTUAL_HOST}
    # cli has to be up before web
    depends_on:
      - cli
```

**2.** In the `cli` service there is a volumes section. You should not remove or change these volumes.

```yaml
  cli:
    volumes:
      # Project root volume
      - project_root:/var/www:rw
      # Host home volume (for SSH keys and other credentials).
      - host_home:/.home:ro
      # Shared ssh-agent socket
      - docksal_ssh_agent:/.ssh-agent:ro
```

<a name="checking"></a>
## Checking the current project configuration

To review the configuration applied to your project run:

```bash
fin config
```

It will not show you the contents or your configuration files directly. Instead, it will compile them together to show you the final static configuration. Some important environment variables will be listed at the top.  

The `COMPOSE_FILE` section displays files that were used to produce this configuration. See [configuration files load order](#loading-order) for understanding the reasons why these files were picked.

You will see output similar to the following:

```yml
COMPOSE_PROJECT_NAME: myproject
COMPOSE_PROJECT_NAME_SAFE: myproject
COMPOSE_FILE:
/Users/testuser/.docksal/stacks/volumes-bind.yml
/Users/testuser/.docksal/stacks/stack-default.yml

PROJECT_ROOT: /Users/testuser/projects/myproject
DOCROOT: docroot
VIRTUAL_HOST: myproject.docksal
IP: 192.168.64.100

MYSQL_PORT:

Docker Compose configuration
---------------------
networks: {}
services:
  cli:
    hostname: cli
    image: docksal/cli:1.0-php7
    volumes:
    - host_home:/.home:ro
    - docksal_ssh_agent:/.ssh-agent:ro
    - project_root:/var/www:rw
  db:
    environment:
      MYSQL_DATABASE: default
      MYSQL_PASSWORD: user
      MYSQL_ROOT_PASSWORD: root
      MYSQL_USER: user
    hostname: db
    image: docksal/db:1.0-mysql-5.5
  web:
    depends_on:
    - cli
    environment:
      APACHE_DOCUMENTROOT: /var/www/docroot
      VIRTUAL_HOST: myproject.docksal
    hostname: web
    image: docksal/web:1.0-apache2.2
    labels:
      io.docksal.project-root: /Users/testuser/projects/myproject
      io.docksal.virtual-host: myproject.docksal
    volumes:
    - project_root:/var/www:ro
version: '2.0'
volumes:
  docksal_ssh_agent:
    external: true
    external_name: docksal_ssh_agent
  host_home:
    driver: local
    driver_opts:
      device: /Users/testuser
      o: bind
      type: none
  project_root:
    driver: local
    driver_opts:
      device: /Users/testuser/projects/myproject
      o: bind
      type: none

---------------------
```

<a name="php-version"></a>
## Switching PHP versions

The PHP version is defined by the `cli` service. The default image used is `docksal/cli:1.0-php7` which uses PHP 7.

A service image name consists of two parts: a docker image name and it's tag.
Here `docksal/cli` is the name of the docker image, while `1.0-php7` is it's tag.

To switch PHP versions you need to change the image used for the `cli` container to your desired one.

[How to find out all supported PHP versions?](#docksal-images)

### Extend or modify config with `docksal-local.yml` or `docksal.yml`

If you use zero-configuration (or any other) you can change the used images with `docksal-local.yml`.

The same technique is **applicable to `dosksal.yml` if `DOCKSAL_STACK` is set in `docksal.env`**. In this case,
`docksal.yml` will extend/modify the configuration instead of overriding it.

You can change the PHP version used by providing an `image` value for the `cli` container.

For example, in `docksal-local.yml` or `docksal.yml`:

```yaml
version: "2.1"

services:
  # CLI
  cli:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: cli
    image: docksal/cli:1.0-php5
```

`docksal-local.yml` will append or modify the configuration that was loaded before it, regardless of whether it was `stack-default.yml` or `docksal.yml`.

`docksal.yml` will append or modify the configuration only if `DOCKSAL_STACK` is set in `docksal.env`.

### Override config with `docksal.yml`

If you don't use any stack (`docksal.yml` is present and `DOCKSAL_STACK` is not set) then you are in control of everything.
You won't inherit anything from `services.yml`, so you should fully describe the `cli` container.

An example section of a `docksal.yml` file that describes the `cli` container and overrides the PHP version:

```yaml
services:
  cli:
    hostname: cli
    image: docksal/cli:1.0-php5
    volumes:
    - host_home:/.home:ro
    - docksal_ssh_agent:/.ssh-agent:ro
    - project_root:/var/www:rw
```

Note, that you **should** fully describe all other services (web, db, etc.) as well if you don't use a stack.

<a name="mysql-version"></a>
## Switching MySQL versions

Switching MySQL versions is performed in the same way as the PHP version switch, but you need to switch the image for the `db` service.

<a name="docksal-images"></a>
## Docksal images and versions

To see all Docker Hub images produced and supported by Docksal team run:

```
fin config images
```

To get all tags of a certain image provide its name with the same command. E.g.:

```
fin config images docksal/db
```

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](custom-commands.md).
E.g. `fin init`, which will call `.docksal/commands/init`. Put project specific initialization tasks there, like:

- initialize the Docksal configuration.
- import databases or perform a site install.
- compile SASS.
- run DB updates, special commands, etc.
- run Behat tests.

For a working example of a Docksal powered project with `fin init` take a look at:

- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)
- [WordPress sample project](https://github.com/docksal/wordpress)
