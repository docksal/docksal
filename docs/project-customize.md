# Customize project configuration

It is recommended to read [Docksal Stack](docksal-stack.yml) explanation before reading this.
You should understand what project containers are, which configuration files Docksal uses and their loading order.

1. [Understanding configurations](#basics)
2. [Default stacks](#default-configurations)
3. [Zero-configuration](#zero-configuration)
4. [Custom configuration](#custom-configuration)
5. [Don't break your Docksal setup! List of must have values.](#warning)
6. [Checking your configuration](#checking)

**Docksal Images**

1. [Switching PHP version](#php-version)
2. [Switching MySQL version](#mysql-version)
3. [Finding supported PHP/MySQL/etc. versions](#docksal-images)

<a name="basics"></a>
### Understanding configurations

yml files are [Compose Files](https://docs.docker.com/compose/compose-file/). Please read documentation on what their main sections are.

!!! danger "REMEMBER DOCKSAL REQUIREMENTS"
    Some containers and their parameters are must have for Docksal to work properly. **Please see [Don't break your Docksal setup!](#warning) section.**

You need to run `fin start` to apply configuration changes. If you removed services or volumes you need to remove them with `fin rm [service]`.

<a name="default-configurations"></a>
## Default stacks

Docksal ships with a set of default configurations (stacks), that are yml files stored in `~/.docksal/stacks/`.
These files are a good starting point of reference when you begin creating your own project configuration.

!!! warning "DO NOT CHANGE DEFAULT STACKS!"
    You should not change or customize existing default stacks. You should use `.docksal` folder in your project to customize your project configuration.

| File name                  | Description |
|----------------------------|:------------|
| `volumes-*.yml`            | Different binding for Docker volumes. Default is `volume-bind.yml`. Used always for volumes binding|
| `services.yml`             | **Main file. Contains default services descriptions**. Used zero-configuration |
| `stack-default.yml`        | Default stack with 3 services that inherits `services.yml`. Used for zero-configuration |
| `stack-default-static.yml` | Same as `stack-default.yml` but does not inherit `services.yml`|
| `stack-acquia.yml`         | Acquia-like stack with Solr, Varnish and memcached. Inherits `services.yml`|

<a name="zero-configuration"></a>
## Zero-configuration

You can simply create a `.docksal` folder in you project root and run `fin start`.
`stack-default.yml` will be used to create containers in this case. This is a great way
to start developing a project or can be used all the time if it's one or two people project.
`stack-default.yml` inherits `services.yml` so you'll get latest versions of containers.

### Zero-configuration stacks

You can switch between pre-created zero-configuration stacks by adding a following line to your `docksal.env` file and running `fin reset`.

```
DOCKSAL_STACK="acquia"
```

There are following stacks present:
- `default` - web, db, cli (assumed, when none specified)
- `acquia` - web, db, cli, varnish, memcached, solr

<a name="custom-configuration"></a>
### Custom configuration

When you start a larger project, that needs customizations to default or non-default services.
A project where CI server is involved or there are many people and you need to maintain software versions across the team.
Or if you just want to protect your configuration from future `services.yml` updates, then you need to generate your own configuration.

```bash
fin config generate
```

It will create `docksal.yml` by copying `stack-default-static.yml` file.
This file has fully independent descriptions of services. Future changes to `services.yml` will not affect your config.

Which also means that if future Docksal update brings new features and changes to `services.yml`, then you might need to re-generate
or re-create your static configuration or append those changes manually to your `docksal.yml` if you want to benefit from those new features.

<a name="warning"></a>
### Don't break your Docksal setup! List of must have values.

!!! important "REQUIREMENTS"
    Some must have values for your Docksal stack to work properly.

There are some values that are not required for docker-compose to work but are required for Docksal stack to function.

**1.** In `web` service these are a volume, labels, environment variables and a dependency. You should not remove ro change these volume, labels or variables.

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

**2.** In `cli` service it's a volumes section. You should not remove or change these volumes.

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
## Checking current project configuration

To review configuration applied to your project run:

```bash
fin config
```

It will not show you the contents or your configuration files. It will compile and glue them to show you final static configuration with variables resolved. Some important environment variable will be show on top of that.
`COMPOSE_FILE` section displays files that were used to produce this configuration. See [configuration files load order](#loading-order) for understanding reasons why these files were picked.

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
## Switching PHP version

PHP version is defined by `cli` service. Default used image is `docksal/cli:1.0-php7` so default is PHP 7.
To switch PHP version you need to change image for `cli` container to the desired one.

A service image name consists of two parts: a docker image name and it's tag.
Here `docksal/cli` is the name of the docker image, while `1.0-php7` is it's tag.

[How to find out all supported PHP versions?](#docksal-images)

### Overriding with `docksal-local.yml`

If you use zero-configuration (or any other) you can override images with `docksal-local.yml`.
Change PHP version by overriding `image` value for `cli` container.

Example `docksal-local.yml`:

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

`docksal-local.yml` will append to or modify configuration what was loaded before it, regardless of whether it was `stack-default.yml` or `docksal.yml`.

### Overriding with `docksal.yml`

If you don't use any zero-configuration stack then you are in control of everything.
You don't inherit `services.yml` so you should fully describe `cli` container.

Example of **part** of `docksal.yml` with configuration for `cli` overriding PHP version:

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

<a name="mysql-version"></a>
## Switching MySQL version

Switching MySQL version is performed it the same way as PHP version switch, but you need to switch the image for the `db` service.

<a name="docksal-images"></a>
## Docksal images and versions

To see all Docker Hub images produced and supported by Docksal team run:

```
fin config images
```

To get all tags of a certain image feed it's name to the same command. E.g.:

```
fin config images docksal/db
```

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](custom-commands.md).
E.g. `fin init`, which will call `.docksal/commands/init`. Put project specific initialization tasks there, like:

- initialize Docksal configuration
- import database or perform a site install
- compile SASS
- run DB updates, special commands, etc.
- run Behat tests

For a working example of a Docksal powered project with `fin init` take a look at:

- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)
- [WordPress sample project](https://github.com/docksal/wordpress)
