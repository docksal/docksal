# Docksal Stack

This page explains how Docksal works under the hood.

1. [System services](#docksal-system-services)
2. [Project services](#docksal-project-services)
3. [Understanding configuration](#understanding-configuration)
    1. [docksal.yml](#docksal-yml)
    2. [docksal.env](#docksal-env)
    3. [Local overrides](#docksal-local)
    4. [Configuration files load order](#loading-order)
4. [Customizing project configuration](#project-customization)

---

<a name="docksal-system-services"></a>
## System services

When you run `fin update` for the first time, Docksal installs several system containers.  
To see the list run `fin docker ps --filter "label=io.docksal.group=system"`

### SSH Agent

[docksal-ssh-agent](https://github.com/docksal/service-ssh-agent) service stores SSH keys and makes them available 
to other projects and containers. Without it you would have to mount your SSH keys into every project where you needed them.  
Also, if your keys are password protected, you would need to enter password each time they are used. ssh-agent takes care of that as well.

ssh-agent imports your keys only once and allows their reuse throughout all running projects without a need to re-enter 
the passphrase, which can be especially annoying if you need an ssh key to checkout/commit to a repo.

### DNS

[docksal-dns](https://github.com/docksal/service-dns) contains a running `bind` server that resolves `*.docksal` URI's 
to the Docksal VM IP address (or localhost if you're running a [native Docker app](env-setup-native.md)).

!!! warning "Windows users"
    On macOS and Linux Docksal automatically configures itself to become a DNS resolver for `.docksal` domain. 
    On Windows this is not configured automatically, because this may cause DNS resolution issues in case the VM is down or freezes.  
    You can manually configure `192.168.64.100` to be your primary DNS and you ISP/office DNS to be the secondary one.

### Reverse proxy

When you request `project.docksal` in your browser, Docksal's DNS resolves it to Docksal's IP and your request hits the 
[docksal-vhost-proxy](https://github.com/docksal/service-vhost-proxy) container. 
This is Docksal's reverse proxy service, which routes the request to the appropriate project's `web` container. 
This allows for a seamless work with multiple project stacks at the same time.

<a name="docksal-project-services"></a>
## Project services

A standard Docksal project consists of 3 canonical services: `web`, `db` and `cli`. These services represent the LAMP stack.

### Web

Docksal's [Web service](https://github.com/docksal/service-web) runs Apache Server 2.2 or 2.4

### DB

Docksal's [DB service](https://github.com/docksal/service-db) runs MySQL 5.5, 5.6, 5.7 or 8.0

### CLI

Docksal's [CLI service](https://github.com/docksal/service-cli) provides an environment to run `php-fpm`,
which is used by `web` service, as well as for Behat, mysql client, drush and other tools. It provides a reliable automation
interface via `fin exec`.

<a name="understanding-configuration"></a>
## Understanding configuration

Docksal relies on [Docker Compose](https://docs.docker.com/compose/) to launch groups of related containers.
You want to familiarize yourself with [basic concepts](https://docs.docker.com/compose/overview/) of Docker Compose
before reading further sections.

<a name="docksal-yml"></a>
### docksal.yml

`docksal.yml` is a [Compose file](https://docs.docker.com/compose/compose-file/).
It's a main configuration file for a project that controls it's services settings, so use it to
modify settings, that are required for all team members.

Even if you don't have this file in your project folder, fin will load a default one providing a zero-configuration ability.

For more details on it's role check [loading order](#loading-order) and [customizing project configuration](project-customize.md).

<a name="docksal-env"></a>
### docksal.env

`docksal.env` is an [Environment file](https://docs.docker.com/compose/env-file/).

It is meant to be used to easily override some default environment variables without a need of
creating `docksal.yml` (for example to override MYSQL_ROOT_PASSWORD) or to provide additional environment
variables to your automation scripts (see [custom commands](custom-commands.md)).

<a name="docksal-local"></a>
### Local overrides

`docksal-local.yml` and `docksal-local.env` can be used those for customizations, which should not
get committed into the project's repository. For example [exposing custom port](expose-port.md) for local development needs.

<a name="loading-order"></a>
## Configuration files load order

This swarm of configuration files that Docksal can use, provides flexibility to set up your
project in a way that works for your team's needs. Just like Bash configuration files
(/etc/profile, bashrc, bash_profile, bash_logout), they provide flexibility to configure Docksal
project in dozens of ways.

`fin` loads files in a certain order. Configuration files, that are loaded later, overwrite settings
from files, that had been loaded earlier. The list below goes from earliest to latest in this queue.
Files at the bottom load the latest.

You can always see files that were loaded for a project by running `fin config show`.

Load order:

1. `volumes-*.yml` - [optional] default is `volumes-bind.yml` ([volumes in Docksal](docksal-volumes.md))  
2. `~/.docksal/stacks/stack-default.yml` - default stack, only loads if there is no `docksal.yml`  
3. `docksal.yml`  
4. `docksal.env`  
5. `docksal-local.yml`  
6. `docksal-local.env`

<a name="project-customization"></a>
## Customizing project configuration

If you are ready to customize Docksal settings for your project then check out [Customizing project configuration](project-customize.md) 
to learn about `docksal.yml` structure and differences between dynamic and static configurations for a project.
