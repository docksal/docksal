# Docksal Stack

This page explains how Docksal works under the hood.

1. [System services](#docksal-system-services)
2. [Project services](#docksal-project-services)
3. [Customizing project configuration](#project-customization)

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

<a name="project-customization"></a>
## Customizing project configuration

If you are ready to customize Docksal services' settings for your project then check out [customizing project configuration](project-customize.md)
to learn about `docksal.yml` structure and how to properly edit it.
