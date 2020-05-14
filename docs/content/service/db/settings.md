---
title: "db: Settings"
---

## MySQL Configuration {#mysql-config}

The following settings files in the project codebase can be used to override default MySQL settings:

- `.docksal/etc/mysql/my.cnf`

Copy `examples/.docksal/etc` from the [Docksal](https://github.com/docksal/docksal) project repo into the `.docksal` 
folder in your project repo and modify as necessary.

Apply changes with `fin project restart` (`fin p restart`).

## Using Different MySQL Versions {#mysql-versions}

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `DB_IMAGE` variable in `.docksal/docksal.env`, e.g.:

```bash
DB_IMAGE='docksal/db:1.1-mysql-5.7'
```
This can also be set with `fin config set`.
```bash
fin config set DB_IMAGE='docksal/db:1.1-mysql-5.7'
```

Remember to run `fin project start` (`fin p start`) to apply the configuration.

{{% notice warning %}}
Different MySQL versions may not be fully compatible. A complete `db` service reset (`fin project reset db`) might be necessary
followed by a DB re-import.
{{% /notice %}}

Available images:

- MySQL 5.5 - `docksal/db:1.1-mysql-5.5`
- MySQL 5.6 - `docksal/db:1.1-mysql-5.6` (default)
- MySQL 5.7 - `docksal/db:1.1-mysql-5.7`
- MySQL 8.0 - `docksal/db:1.1-mysql-8.0`

There are also "edge" versions available that contain code from ongoing updates, but may not be stable. Don't switch to an
edge image unless directed to do so by the Docksal team for testing purposes only.

