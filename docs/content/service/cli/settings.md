---
title: "cli: Settings"
---

## PHP Configuration {#configuration}

The following settings files in the project codebase can be used to override default PHP settings:

- `.docksal/etc/php/php.ini` - global PHP (web and cli) settings overrides
- `.docksal/etc/php/php-fpm.conf` - PHP-FPM (web) overrides on top of what's set globally

{{% notice note %}}
Some PHP-FPM (web) settings set by default in the cli container cannot be overridden via `php.ini`.  
{{% /notice %}}

The following settings have to be overridden using the `php_admin_value` directive in `php-fpm.conf`:

 - `memory_limit`
 - `max_execution_time`
 - `upload_max_filesize`
 - `post_max_size`
 - `max_input_vars`

{{% notice tip %}}
It is recommended to add PHP settings overrides in both `php.ini` and `php-fpm.conf` at the same time.
{{% /notice %}}

You can find example settings overrides [here](https://github.com/docksal/docksal/tree/develop/examples/.docksal/etc/php).

Once settings are in place, apply changes with `fin project restart` (`fin p restart`).

## Using Different PHP Versions {#php-versions}

Different PHP versions are handled via using different `cli` service images.  

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `CLI_IMAGE` variable in `.docksal/docksal.env`, e.g.:

```
CLI_IMAGE='docksal/cli:2.11-php7.3'
```

This can also be set with `fin config set`.

```bash
fin config set CLI_IMAGE='docksal/cli:2.11-php7.3'
```

Run `fin project reset cli` (`fin p reset cli`) to properly reset and update the `cli` service.

Available PHP versions: 7.3, 7.4 supported, and 7.2, 7.1, 7.0, 5.6 deprecated. Check the [list of the available CLI images](/stack/images-versions#cli) for the full list. 

There are also "edge" versions available that contain code from ongoing updates, but may not be stable. Don't switch to an
edge image unless directed to do so by the Docksal team for testing purposes only.

See documentation for projects using a [custom stack configuration](/stack/custom-configuration/).

## Using Different Composer versions {#composer}

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
