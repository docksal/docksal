---
title: "MySQL settings"
---

<a name="configuration"></a>
## MySQL configuration

The following settings files in the project codebase can be used to override default MySQL settings:

- `.docksal/etc/mysql/my.cnf`

Copy `examples/.docksal/etc` from the [Docksal](https://github.com/docksal/docksal) project repo into the `.docksal` 
folder in your project repo and modify as necessary.

Apply changes with `fin project restart` (`fin p restart`).

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

See documentation for projects using a [custom stack configuration](/stack/config/#mysql-version).
