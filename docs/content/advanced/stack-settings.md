---
title: "PHP and MySQL settings"
---


<a name="configuration"></a>
## PHP and MySQL configuration

When the following settings files are added to a project, they can be used to override the defaults.

- `.docksal/etc/php/php.ini` - global PHP (web and cli) settings overrides
- `.docksal/etc/php/php-fpm.conf` - PHP-FPM (web) only settings overrides
- `.docksal/etc/mysql/my.cnf` - MySQL settings overrides

Note: for `docksal/cli` images prior to version 2.0 the following files are used to override PHP settings:

- `.docksal/etc/php/php.ini` - PHP settings overrides
- `.docksal/etc/php/php-cli.ini` - command line PHP settings overrides

Copy `examples/.docksal/etc` from the [Docksal](https://github.com/docksal/docksal) project repo into the `.docksal` 
folder in your project repo and modify as necessary.

Apply changes with `fin project restart` (`fin p restart`).

<a name="php-versions"></a>
## Using different PHP versions

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

See documentation for projects using a [custom stack configuration](../advanced/stack-config.md#php-version).

<a name="mysql-versions"></a>
## Using different MySQL versions

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `DB_IMAGE` variable in `.docksal/docksal.env`.

```bash
DB_IMAGE='docksal/db:1.1-mysql-5.6'
```

Remember to run `fin project start` (`fin p start`) to apply the configuration.

{{% notice warning %}}
Different MySQL versions may not be fully compatible. A complete `db` service reset (`fin project reset db`) might be necessary
followed by a DB re-import.
{{% /notice %}}

Available images:

- MySQL 5.5 - `docksal/db:1.1-mysql-5.5`
- MySQL 5.6 - `docksal/db:1.1-mysql-5.6`
- MySQL 5.7 - `docksal/db:1.1-mysql-5.7`
- MySQL 8.0 - `docksal/db:1.1-mysql-8.0`

See documentation for projects using a [custom stack configuration](../advanced/stack-config.md#mysql-version).
