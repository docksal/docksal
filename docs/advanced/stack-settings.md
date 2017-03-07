# Overriding default PHP/MySQL/etc. settings

<a name="configuration"></a>
## Altering PHP and MySQL configuration

When the following settings files are added to the project, they can be used to override the defaults.

- `.docksal/etc/php/php.ini` - PHP settings overrides
- `.docksal/etc/php/php-cli.ini` - command line PHP settings overrides
- `.docksal/etc/mysql/my.cnf` - MySQL settings overrides

Copy `examples/.docksal/etc` from the [Docksal](https://github.com/docksal/docksal) project repo into the `.docksal` 
folder in your project repo and modify as necessary.

!!! important "Applying the settings changes"
    When adding the settings files initially into a project a reset is necessary for containers to pick them up properly.  
    Run `fin reset cli` for PHP and `fin reset db` for MySQL (**WARNING: this will destroy your database!**).  
    When the settings files are already in place, configuration changes can be propagated by restarting the containers 
    with `fin restart`.

<a name="php-versions"></a>
## Using different PHP versions

Different PHP versions are handled via using different `cli` service images.  

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `CLI_IMAGE` variable in `.docksal/docksal.env`.

```bash
CLI_IMAGE='docksal/cli:1.1-php5'
```

Remember to run `fin up` to apply the configuration.

Available images:

- PHP 5 - `docksal/cli:1.1-php5`
- PHP 7 - `docksal/cli:1.1-php7`

For projects using a custom stack configuration check [here](project-customize.md#php-version).

<a name="mysql-versions"></a>
## Using different MySQL versions

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `DB_IMAGE` variable in `.docksal/docksal.env`.

```bash
DB_IMAGE='docksal/db:1.0-mysql-5.5'
```

Remember to run `fin up` to apply the configuration.

!!! warning "MySQL versions compatibility"

    Different MySQL versions may not be fully compatible. A complete `db` service reset (`fin reset db`) might be necessary 
    followed by a DB re-import.

Available images:

- MySQL 5.5 - `docksal/db:1.0-mysql-5.5`
- MySQL 5.6 - `docksal/db:1.0-mysql-5.6`
- MySQL 5.7 - `docksal/db:1.0-mysql-5.7`
- MySQL 8.0 - `docksal/db:1.0-mysql-8.0`

For projects using a custom stack configuration check [here](project-customize.md#mysql-version).
