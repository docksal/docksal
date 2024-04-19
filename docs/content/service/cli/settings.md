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

[See example settings overrides](https://github.com/docksal/docksal/tree/develop/examples/.docksal/etc/php).

Once settings are in place, apply changes with `fin project restart` (`fin p restart`).

## Using Different PHP Versions {#php-versions}

Different PHP versions are handled via using different `cli` service images.  

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `CLI_IMAGE` variable in `.docksal/docksal.env`, e.g.:

```
CLI_IMAGE='docksal/cli:php8.3-3.8'
```

This can also be set with `fin config set`.

```bash
fin config set CLI_IMAGE='docksal/cli:php8.3-3.8'
```

Run `fin project reset cli` (`fin p reset cli`) to properly reset and update the `cli` service.

You can find the list of CLI images and corresponding PHP versions [here](/stack/images-versions#cli).

There are also "edge" versions available that contain code from ongoing updates, but may not be stable. Don't switch to an
edge image unless directed to do so by the Docksal team for testing purposes only.

See documentation for projects using a [custom stack configuration](/stack/custom-configuration/).
