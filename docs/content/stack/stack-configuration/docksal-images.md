---
title: "Docksal images"
weight: 3
aliases:
  - /en/master/advanced/stack-config/
---
## Switching PHP versions {#php-version}

The PHP version is defined by the `cli` service. The default image used is `docksal/cli:2.5-php7.1`, which uses PHP 7.1.

A service image name consists of two parts: a docker image name and a tag.
`docksal/cli` is the name of the docker image, while `2.4-php7.1` is the image tag.

To switch PHP versions you have to change the image used for the `cli` service to your desired one.  

Note: if the project stack is already running, then apply the changes with `fin project reset cli`. This will properly
reset and update the `cli` service.

[How to find out all supported PHP versions?](#docksal-images)

### Extend or modify config with docksal-local.yml or docksal.yml

When using zero-configuration (or any other), the service image can be overridden in `docksal-local.yml`.

The same technique is **applicable to `docksal.yml` if `DOCKSAL_STACK` is set in `docksal.env`**. In this case,
`docksal.yml` will extend/modify the stack configuration defined in `DOCKSAL_STACK` instead of overriding it.

To switch the PHP version override the `image` value for the `cli` service.

For example, in `docksal-local.yml` or `docksal.yml`:

```yaml
version: "2.1"

services:
  cli:
    image: docksal/cli:2.5-php7.2
```

`docksal-local.yml` will append or modify the configuration that was loaded before it, regardless of whether it was 
`stack-default.yml` or `docksal.yml`.

`docksal.yml` will append or modify the configuration only if `DOCKSAL_STACK` is set in `docksal.env`.

### Override config with docksal.yml

When not using a predefined stack (`docksal.yml` is present and `DOCKSAL_STACK` is not set in `docksal.env`), 
you are in control of everything. In this case the stack configuration is not inherited from 
`services.yml` (`$HOME/.docksal/services.yml`), so you must fully describe the `cli` service in the project's `docksal.yml`.

An example section of a `docksal.yml` file that describes the `cli` service and overrides the PHP version:

```yaml
services:
  cli:
    hostname: cli
    image: docksal/cli:2.5-php7.2
    volumes:
    - docksal_ssh_agent:/.ssh-agent:ro
    - project_root:/var/www:rw,nocopy
```

Note: when not using a predefined stack, you must fully describe all other services (`web`, `db`, etc.) as well.

## Switching MySQL versions {#mysql-version}

Switching MySQL versions is performed in the same way as the PHP version switch. 
Instead of the `cli` service image you will be modifying the `db` service image.

## Docksal images and versions {#docksal-images}

To see all Docker Hub images produced and supported by Docksal team run:

```bash
fin image registry
```

To get all tags of a certain image provide its name with the same command. For example:

```bash
fin image registry docksal/db
```

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](/fin/custom-commands/) (e.g., `fin init`, which will call `.docksal/commands/init`). Put project specific initialization tasks there, like:

- initialize the Docksal configuration
- import databases or perform a site install
- compile SASS
- run DB updates, special commands, etc.
- run Behat tests

### Sample projects

For a working example of a Docksal powered project with `fin init` take a look at:

- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)
- [WordPress sample project](https://github.com/docksal/wordpress)
