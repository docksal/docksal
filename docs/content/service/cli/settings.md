---
title: "PHP settings"
---

## PHP configuration {#configuration}

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

## Using different PHP versions {#php-versions}

Different PHP versions are handled via using different `cli` service images.  

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `CLI_IMAGE` variable in `.docksal/docksal.env`.

```bash
CLI_IMAGE='docksal/cli:2.5-php7.1'
```

Run `fin project reset cli` (`fin p reset cli`) to properly reset and update the `cli` service.

Available images:

- PHP 5.6 - `docksal/cli:2.5-php5.6`
- PHP 7.0 - `docksal/cli:2.5-php7.0`
- PHP 7.1 - `docksal/cli:2.5-php7.1`
- PHP 7.2 - `docksal/cli:2.5-php7.2`

See documentation for projects using a [custom stack configuration](/stack/config/#php-version).
