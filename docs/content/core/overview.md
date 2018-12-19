---
title: "How Docksal works"
weight: 1
aliases:
  - /en/master/advanced/stack/
---


This section explains how Docksal works under the hood.

## System services {#docksal-system-services}

When you run `fin update` for the first time, Docksal installs several system containers.  
To see the list, run `fin docker ps --filter "label=io.docksal.group=system"`.

### SSH agent

The [docksal-ssh-agent](https://github.com/docksal/service-ssh-agent) service stores SSH keys and makes them available 
to other projects and containers.

SSH agent can handle passphrase protected ssh keys, so you don't have to enter the passphrase every time the key is used. 
The passphrase is entered one only time, when the key is loaded into the agent.

See [Using ssh-agent service](/core/system-ssh-agent/) for more information. 

### DNS

[docksal-dns](https://github.com/docksal/service-dns) contains a running `dnsmasq` server that resolves `*.docksal` URI's 
to the Docksal VM IP address (or localhost if you're running a [native Docker app](/getting-started/docker-modes/)).

See [DNS resolver](/core/system-dns/) for more information.

### Reverse proxy

When you request `project.docksal` in your browser, Docksal's DNS resolves it to Docksal's IP and your request hits the 
[docksal-vhost-proxy](https://github.com/docksal/service-vhost-proxy) container. 
This is Docksal's reverse proxy service, which routes the request to the appropriate project's `web` container. 
This allows for a seamless work with multiple project stacks at the same time.

## Project services {#docksal-project-services}

Each project usually consists of at least 3 services: `web`, `db`, and `cli`.

### web

The [web](https://github.com/docksal/service-web) service runs Apache server 2.2 or 2.4.

### mysql

The [mysql](https://github.com/docksal/service-db) service runs MySQL 5.5, 5.6, 5.7, or 8.0.

### cli

The [cli](https://github.com/docksal/service-cli) service runs `php-fpm` (used by `web` service) and also provides 
a Linux console with all necessary command line tools installed and pre-configured 
(e.g., drush, drupal console, wp-cli, phpcs, behat, mysql client, and many more).

The console can be accessed from the host machine via `fin bash`. Individual tools/binaries can be executed via `fin exec`.

## Customizing project configurations {#project-customization}

If you are ready to customize Docksal service settings for your project, then check out [Customizing project configurations](/stack/config/)
to learn about the `docksal.yml` structure and how to properly edit it.
