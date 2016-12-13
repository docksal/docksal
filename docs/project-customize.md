# Customize project configuration

## Checking the default configuration

If you had setup a project using the [simplified process](project-setup.md), then Docksal will handle all the configuration
behind the scenes.

To review configuration applied to your project run

```bash
fin config
```

You will see output similar to the following:

```yml
COMPOSE_PROJECT_NAME: myproject
COMPOSE_PROJECT_NAME_SAFE: myproject
COMPOSE_FILE:
/Users/testuser/.docksal/stacks/volumes-bind.yml
/Users/testuser/.docksal/stacks/stack-default.yml
ENV_FILE:


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

This output represents the very final containers configuration, composed of all your configuration files with all variables resolved to their values.

## Customizing a configuration

Out-of-the box dynamic configuration is no different than static one. The only difference is how each of them handles future Docksal updates.

### Dynamic configuration (recommended)

Dynamic configuration is the one that can be generated with:

```bash
fin config generate
```

It will create `docksal.yml` using `stack-default.yml` file. This type of configuration extends default `services.yml` file. Advantage is that your configuration is much more simple, which leaves less space for error (especially for unexperienced developers) and it will update to the latest version of Docksal images and practices automatically, while with static configuration manual updates might be required. Cons is that `services.yml` may change with Docksal updates, which is not always desirable with more complex projects. 

Dynamic configuration approach is recommended for majority projects with default setups. When you don't need anything more than webserver, database and some dev tools. This Drupal or Wordpress project of low to medium complexity. In majority of cases Docksal updates will not affect such project.

**If you're not sure what to choose, this one is recommended. You can always switch to static one.**

### Static configuration (advanced)

When you start a larger project with customizations to defaults or non-default services, or with the big team of people, then you probably want to generate a static configuration, that will not depend on `services.yml`.

This can be done with additional parameter:

```bash
fin config generate --static
```

It will create `docksal.yml` using `stack-default-static.yml` file. This file has static images' names and none of future changes to `services.yml` will affect it. 

Which also means that if future Docksal update brings new features, that require a change to `services.yml`, then unlike with dynamic configuration, you might need to re-generate your static configuration or append those changes manually to your `docksal.yml` if you want to benefit from those new features.

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
