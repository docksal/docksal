# Customize project configuration

It is recommended to read [Docksal Stack](docksal-stack.yml) explanation before reading this.
You should understand what project containers are, which configuration files Docksal uses and their loading order.

1. [Understanding configurations](#basics)
2. [Default configurations](#default-configurations)
3. [Zero-configuration](#zero-configuration)
4. [Generating custom configuration](#generating)
  1. [Dynamic](#dynamic)
  2. [Static](#static)
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
    Some containers and their parameters are must have for Docksal to work properly. Please see [Don't break your Docksal setup!](#warning) section.**

You need to run `fin start` to apply configuration changes. If you removed services or volumes you need to remove them with `fin rm [service]`.

<a name="default-configurations"></a>
## Default configurations

Docksal ships with a set of default configurations (stacks), that are yml files stored in `~/.docksal/stacks/`.
These files are a good starting point of reference when you begin creating your own project configuration.

!!! warning "DO NOT CHANGE DEFAULT STACKS!"
    You should not change or customize existing default stacks. You should use `.docksal` folder in your project to customize your project configuration.

| File name                  | Description |
|----------------------------|:------------|
| `volumes-*.yml`            | Different binding for Docker volumes. Default is `volume-bind.yml` |
| `services.yml`             | **Main file. Contains default services descriptions** |
| `stack-default.yml`        | Default stack with 3 services that inherit `services.yml` |
| `stack-default-static.yml` | Same as `stack-default.yml` but does not inherit `services.yml`|
| `stack-acquia.yml`         | Acquia-like stack with Solr, Varnish and memcached. Inherits `services.yml`|
| `stack-acquia.yml`         | Same as `stack-acquia.yml` but does not inherit `services.yml` |


| File name                  | Used for |
|----------------------------|:------------|
| `volumes-*.yml`            | `volume-bind.yml` used always for volumes binding |
| `services.yml`             | Used for dynamic and zero-configuration |
| `stack-default.yml`        | Used for zero-configuration |
| `stack-default-static.yml` | Used for `fin config generate --static`|
| `stack-acquia.yml`         | Used for `fin config generate acquia` |
| `stack-acquia.yml`         | Used for `fin config generate acquia --static` |

<a name="zero-configuration"></a>
## Zero-configuration (recommended)

Docksal supports zero-configuration approach. If you simply create a `.docksal` folder in you project root and run `fin start`
then `stack-default.yml` will be used to create containers, which should be a great way for majority of projects that only need
web server and PHP.

<a name="generating"></a>
If you're not going to use zero configuration, but will create a standalone one for your project, then it's recommended to use generation to create initial files. However you can also just copy them manually. It is **not recommended to start from empty Compose File file or use one from other systems.** Docksal has some must have requirements to containers and configurations that should be present in your config for Docksal to work properly.

<a name="dynamic"></a>
### Custom dynamic configuration

Dynamic configuration is the one that can be generated with:

```bash
fin config generate
```

It will create `docksal.yml` by copying `stack-default.yml` file. This type of configuration extends default `services.yml` file. Advantage is that your configuration is much more simple, which leaves less space for error (especially for unexperienced developers) and it will update to the latest version of Docksal images and practices automatically, while with static configuration manual updates might be required. Cons is that `services.yml` may change with Docksal updates, which is not always desirable with more complex projects.

Dynamic configuration approach is recommended for majority of projects that need something more than zero configuration, a Drupal or Wordpress project of low to medium complexity.

**If you're not sure what to choose, this one is recommended. You can always switch to static one.**

!!! note "Why pay more?"
    Out-of-the box dynamic configuration is no different than out-of-the box static one. The only difference is how each of them handles future updates of default configs.

<a name="static"></a>
### Static configuration (advanced)

When you start a larger project, that needs customizations to default or non-default services, or you want to protect from future `services.yml` updates, then you probably want to generate a static configuration, that will not depend on `services.yml`.

This can be done with additional parameter:

```bash
fin config generate --static
```

It will create `docksal.yml` by copying `stack-default-static.yml` file. This file has fully independent descriptions of services. Future changes to `services.yml` will not affect your config.

Which also means that if future Docksal update brings new features and changes to `services.yml`, then you might need to re-generate or re-create your static configuration or append those changes manually to your `docksal.yml` if you want to benefit from those new features.

<a name="warning"></a>
### Don't break your Docksal setup! List of must have values.

!!! important "REQUIREMENTS"
    Some must have values for your Docksal stack to work properly.

There are some values that are not required for docker-compose to work but are required for Docksal stack to function.

**1.** In `web` service these are a volume, labels, and environment veriables. You should not remove ro change these volume, labels or variables.

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

**3.** For static configurations there's an additional requirement to maintain `web` container dependence on `cli`.

```yaml
  web:
    # cli has to be up before web
    depends_on:
      - cli
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

Whether you use zero-configuration or any other you can override images with `docksal-local.yml`.
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

`docksal.yml` prevents `stack-default.yml` from loading so if you are doing it with `docksal.yml`,
then you need to describe all services, not just the one you want to override.

Example of `docksal.yml` dynamic configuration overriding `cli` service image to change used PHP version:

```yaml
version: "2.1"

services:
  # Web
  web:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: web
    depends_on:
      - cli

  # DB
  db:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: db

  # CLI
  cli:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: cli
    image: docksal/cli:1.0-php5
```

### Overriding with `docksal.yml` (static configuration)

If you are using static config, then you are in control of everything. You don't inherit `services.yml` so you should fully describe container.
Example **part** of `docksal.yml` with static configuration for `cli`:

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
