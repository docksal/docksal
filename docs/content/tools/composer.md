---
title: "Composer"
aliases:
  - /en/master/tools/composer/
---


Composer is a tool for dependency management in PHP. It allows you to declare the libraries your project depends on and it will manage (install/update) them for you.

Please refer to the official [Composer documentation](https://getcomposer.org/doc/) for usage details.


## Usage {#usage}

From the host via `fin`:

```
fin composer --version
```

From with the cli container (`fin bash`) composer can be called directly:

```
composer --version
```

{{% notice note %}}
Unless the `--working-dir=` is used, the composer command must be run within the directory or child directory containing the 
project's `composer.json` file.
{{% /notice %}}

{{% notice warning %}}
A composer based Drupal site can require 2GB of RAM to install all components. To provide that RAM to composer inside
the container, Virtual Box/Docker Desktop needs 3GB or more.
{{% /notice %}}


## Using Different Composer versions {#versions}

Starting with v2.12.0 of [docksal/cli](https://github.com/docksal/service-cli), Composer v1 and v2 are both installed 
in the container. v2 is set as the default version, but while not all projects may be able to work with v2 quite yet, 
v1 is available by setting the `COMPOSER_DEFAULT_VERSION` variable to `1`.

```bash
fin config set COMPOSER_DEFAULT_VERSION=1
fin project reset cli
```

The following Composer optimization packages are no longer relevant for v2 and have been dropped in docksal/cli v2.12.0+:

- [hirak/prestissimo](https://github.com/hirak/prestissimo)
- [zaporylie/composer-drupal-optimizations](https://github.com/zaporylie/composer-drupal-optimizations) 

To benefit from both optimizations with Composer v1, you would need to pin the image to an older version:

```bash
# Pick the required (1) PHP version from the list below
fin config set CLI_IMAGE='docksal/cli:2.11-php7.2'
fin config set CLI_IMAGE='docksal/cli:2.11-php7.3'
fin config set CLI_IMAGE='docksal/cli:2.11-php7.4'
# Reset cli to apply changes
fin project reset cli
```
