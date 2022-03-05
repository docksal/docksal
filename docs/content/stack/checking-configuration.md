---
title: "Checking Your Configuration"
weight: 4
aliases:
  - /en/master/advanced/stack-config/
---
## Checking Project Configuration {#checking}

To review the configuration applied to your project run:

```bash
fin config show
```

It does not show the contents or the configuration files directly. Instead, it compiles them together and outputs 
the resulting configuration. Some important environment variables are listed at the top.  

The `COMPOSE_FILE` section displays files that were used to produce this configuration. 
See [configuration files load order](/stack/understanding-stack-config/#loading-order) for more information on how config files are loaded and merged.

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
    image: docksal/cli:php7.4-3.1
    volumes:
    - docksal_ssh_agent:/.ssh-agent:ro
    - project_root:/var/www:rw,nocopy,cached
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
    image: docksal/apache:2.4-2.4
    labels:
      io.docksal.project-root: /Users/testuser/projects/myproject
      io.docksal.virtual-host: myproject.docksal
    volumes:
    - project_root:/var/www:ro,nocopy,cached
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
