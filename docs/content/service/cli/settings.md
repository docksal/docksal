---
title: "PHP settings"
---

## PHP configuration {#configuration}

The following settings files in the project codebase can be used to override default PHP settings:

- `.docksal/etc/php/php.ini` - global PHP (web and cli) settings overrides
- `.docksal/etc/php/php-fpm.conf` - PHP-FPM (web) only settings overrides

Note: for `docksal/cli` images prior to version 2.0 the following files are used to override PHP settings:

- `.docksal/etc/php/php.ini` - PHP settings overrides
- `.docksal/etc/php/php-cli.ini` - command line PHP settings overrides

Copy `examples/.docksal/etc` from the [Docksal](https://github.com/docksal/docksal) project repo into the `.docksal` 
folder in your project repo and modify as necessary.

Apply changes with `fin project restart` (`fin p restart`).

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
