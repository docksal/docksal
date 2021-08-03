---
title: "Understanding Stack Configurations"
weight: 1
aliases:
  - /en/master/advanced/stack-config/
---
1. [Basics](#basics)
2. [Project configuration files](#docksal-yml)
3. [Default stacks](#default-configurations)
4. [Configuration files loading order](#loading-order)

## Basics {#basics}

Docksal relies on [Docker Compose](https://docs.docker.com/compose/) to launch groups of related containers.
The yml files you use are [Compose Files](https://docs.docker.com/compose/compose-file/). 
Please read the documentation to understand their main sections.

{{% notice warning %}}
Some containers and their parameters are required for Docksal to work properly. 
**Please see [Don't break your Docksal setup!](/stack/custom-configuration/#warning) section.**
{{% /notice %}}

You have to run `fin project start` (`fin p start` for short) to apply configuration changes.
If you remove services or volumes you have to remove them with `fin project rm [service]`.

## Project Configuration Files
### docksal.yml {#docksal-yml}

`docksal.yml` is a [Compose file](https://docs.docker.com/compose/compose-file/).
It's the main configuration file for a project and controls the settings for each service. Use it to
modify settings that are needed for anyone that uses your project.

If you don't have this file in your project folder, fin will load the [default stack](#default-configurations), 
this way providing a zero-configuration setup.

For more details on its role, check [loading order](#loading-order).

### docksal.env {#docksal-env}

`docksal.env` is an [Environment file](https://docs.docker.com/compose/env-file/).

It is used to override some of the default environment variables, without the need for
a full `docksal.yml` file (e.g., to override `MYSQL_ROOT_PASSWORD`) or to provide additional environment
variables for your automation scripts (see [custom commands](/fin/custom-commands/)).

### docksal-local.yml, docksal-local.env {#docksal-local}

`docksal-local.yml` and `docksal-local.env` are used for additional customizations that happen after the main files 
are loaded. See [loading order](#loading-order). A good example of their use is [exposing custom ports](/core/networking/#expose-port) 
or switching PHP versions.

These files are intended for local overrides. They should be added to `.gitignore` and never committed into a project 
repo. You can always include an example file in the repo, e.g., `example.docksal-local.env`, and instruct users to copy 
it and adjust as necessary.

## Default Configurations {#default-configurations}

Docksal ships with a set of default configurations (stacks), which are `yml` files stored in `$HOME/.docksal/stacks/`.
These files are a good reference when you begin creating a [custom project configuration](/stack/custom-configuration/).

| File name                  | Description |
|----------------------------|:------------|
| `services.yml`             | Contains default service descriptions. |
| `stack-acquia.yml`         | [Acquia](https://www.acquia.com/) alike stack with Apache, MySQL, PHP-FPM, Solr, Varnish and memcached. |
| `stack-default.yml`        | The default stack with 3 services that inherits `services.yml`. Used for zero-configuration. |
| `stack-default-nodb.yml`   | The default stack sans the `db` service. |
| `stack-node.yml`           | Suitable for NodeJS projects. Consists of the `cli` service only. |
| `stack-pantheon.yml`       | [Pantheon](https://www.pantheon.io/) alike stack with Nginx, MariaDB, PHP-FPM, Solr, Varnish and Redis. |
| `stack-platformsh.yml`     | [Platform.sh](https://platform.sh/) alike stack with Nginx, MariaDB, PHP-FPM, and Redis. |
| `volumes-*.yml`            | Different bindings for Docker volumes. Docksal picks the default based on the host OS/hypervisor. |

To enable a particular stack config, use the `DOCKSAL_STACK` configuration variable in your project:

```bash
fin config set DOCKSAL_STACK="node"
```

{{% notice warning "DO NOT CHANGE DEFAULT STACKS!" %}}
Do not change or customize existing default stacks.  
See [Custom Configuration](/stack/custom-configuration/) to learn how to manage a custom stack configuration in Docksal. 
{{% /notice %}}

## Configuration Files Loading Order {#loading-order}

With this swarm of configuration files, Docksal lets you configure a project in a way that works for you and your team. 
Just like Bash configuration files (/etc/profile, bashrc, bash_profile, bash_logout), they give the flexibility to 
configure a Docksal project in dozens of ways.

`fin` loads files in a certain order. Files loaded later override settings from the files loaded earlier. 
The list below goes from the earliest to the latest in this queue.

Loading order:

1. `$HOME/.docksal/stacks/volumes-*.yml` - only `volumes-bind.yml` loads at the moment ([volumes in Docksal](/core/volumes/))
2. `$HOME/.docksal/stacks/stack-*.yml` - only loads if there is no `docksal.yml` in the project or if forced by setting the `DOCKSAL_STACK` variable in `docksal.env`
3. `docksal.yml` - extends the stack if `DOCKSAL_STACK` is set in `docksal.env` or completely overrides it otherwise
4. `docksal.env` - sets or modifies environment variables
5. `docksal-local.yml` - extends the loaded stack or `docksal.yml`
6. `docksal-local.env` - sets or modifies environment variables set previously

To see the files loaded for a particular project run `fin config show`.

## Docksal Images and Versions {#docksal-images}

To see all Docker Hub images produced and supported by Docksal team run:

```bash
fin image registry
```

To get all tags of a certain image provide its name with the same command. For example:

```bash
fin image registry docksal/cli
```
