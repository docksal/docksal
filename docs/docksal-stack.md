# Docksal Stack

This page explains some hidden mechanics of Docksal.

1. [System services](#docksal-system-services)
2. [Project services](#docksal-project-services)
3. [Understanding configuration](#understanding-configuration)
    1. [What is docksal.yml?](#docksal-yml)
    2. [What is docksal.env?](#docksal-env)
    3. [What docksal-local files are for?](#docksal-local)
    4. [Configuration files loading order](#loading-order)

---

<a name="docksal-system-services"></a>
## System services

When you run `fin update` for the first time Docksal installs you 3 system containers.
These services are required to glue system pieces together.
You can see them if you run `fin docker ps | grep docksal-`

### SSH Agent

[docksal-ssh-agent](https://github.com/docksal/service-ssh-agent) service is required to store your SSH keys. If not this service you would need
to manually map your SSH keys to every project where you need them and if your keys
are password protected you would need to enter password each time.

Instead there's a conatiner with [ssh-agent](https://github.com/docksal/service-ssh-agent) running
that imports your keys once and allows their reuse throughout all running projects
without a need to re-enter passphrase, which could be especially annoying if you need
ssh key to checkout/commit to repo.

### DNS

[docksal-dns](https://github.com/docksal/service-dns) contains a running bind server that resolves `*.docksal` URI's into IP address
of Docksal's VM (or localhost if you're running [native Docker app](env-setup-native.md)).

!!! warning "Windows users"
    On macOS and Linux Docksal automatically configures itself to become a DNS resolver for `.docksal` domain. On Windows it is not get configured automatically because in case when VM freezes or stops Windows might temporarily lose ability to resolve internet addressess into IP's. You can manually set up `192.168.64.100` to be your primary DNS however it's recommended to update hosts file on per-project basis instead.

### Reverse proxy

When you request `project.docksal` in your browser and Docksal's DNS re-routes your request, then next it gets
to [docksal-vhost-proxy](https://github.com/docksal/service-vhost-proxy), Docksal's reverse proxy container, that determines to which project's `web` container
should this request go to. It allows seamless work with multiple projects.

<a name="docksal-project-services"></a>
## Project services

Every Docksal project should contain at least 3 canonical services: web, db and cli.

### Web

Docksal's [Web service](https://github.com/docksal/service-web) runs Apache Server 2.2 or 2.4

### DB

Docksal's [DB service](https://github.com/docksal/service-db) runs MySQL 5.5, 5.6, 5.7 or 8.0

### CLI

Docksal's [CLI service](https://github.com/docksal/service-cli) provides an environment to run php-fpm,
that is used by web service, Behat, mysql, drush and other tools, and provides reliable automation
interface via `fin exec`.

<a name="understanding-configuration"></a>
## Project services advanced configuration

Docksal relies on [Docker Compose](https://docs.docker.com/compose/) to launch groups of related containers.
You want to familiarize yourself with [basic concepts](https://docs.docker.com/compose/overview/) of Docker Compose
before reading next chapters.

<a name="docksal-yml"></a>
### What is docksal.yml?

`docksal.yml` is customly named [Compose file](https://docs.docker.com/compose/compose-file/).
It's a main configuration file for a project that controls it's services settings, so use it to
modify settings, that are required for all team members.

Even if you don't have this file in your project folder fin loads a default one providing a zero-configuration ability.

For more details on it's role check [loading order](#loading-order) and [customizing project configuration](project-customize.md).

<a name="docksal-env"></a>
### What is docksal.env?

`docksal.env` is an [Environment file](https://docs.docker.com/compose/env-file/).

It is meant to be used to easily override some default environment variables without a need of
creating `docksal.yml` (For example to override mysql root password) or to provide additional environment
variables to your automation scripts (see [custom commands](custom-commands.md)).

<a name="docksal-local"></a>
### What docksal-local files are for?

`docksal-local.yml` and `docksal-local.env` are supposed to be used for customizations that should not
get committed to project's repository. For example [exposing custom port](expose-port.md) for local development needs.

<a name="loading-order"></a>
## Configuration files loading order

This swarm of configuration files that Docksal can use, provides a flexibility to setup your
project in a way that works for your organisation needs, just like Bash configuration files
(/etc/profile, bashrc, bash_profile, bash_logout) they provide flexibility to configure Docksal
project in dozens of ways.

fin loads files in a certain order. Configuration files that are loaded later overwrite settings
from files that loaded earlier. The list below goes from earliest to latest in this queue.
Files at the bottom load the latest.

You can always see files that were loaded for project by running `fin config`.

Loading order:

**0.** `volumes-*.yml` - Optional. Default is `volumes-bind.yml`. See [volumes in Docksal](docksal-volumes.md) for details.
**1.** `~/.docksal/stacks/stack-default.yml` - default stack, only loads if there is no `docksal.yml`
**2.** `docksal.yml` - prevents loading default stack.
**3.** `docksal.env`
**4.** `docksal-local.yml`
**5.** `docksal-local.env`

## Customizing project configuration

On details of docksal.yml structure and differences between dynamic and static configurations see [customizing project configuration](project-customize.md).
