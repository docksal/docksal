---
title: "db: Service Options"
weight: 1
---

The default stack uses MySQL for the db service while the pantheon and platformsh stacks use MariaDB.
Docksal has also defined PostreSQL as a db service option. You do not have to make any
configuration changes to use MySQL, but if you want to specify the use of MariaDB or PostreSQL,
you will need to modify your `docksal.yml` file.

## MariaDB Configuration {#mariadb-config}

Docksal has defined a db service with a MariaDB image. To set your db service to use MariaDB
instead of MySQL, set the db service in your `docksal.yml` file.

```yaml
version: "2.1"
services:
  db:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: mariadb
```


## PostreSQL Configuration {#postresql-config}

Docksal has defined a db service with a PostreSQL image. To set your db service to use PostreSQL instead of MySQL,
set the db service in your `docksal.yml` file.

```yaml
version: "2.1"
services:
  db:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: pgsql
```

{{% notice note %}}
Remember to run `fin project start` (`fin p start`) to apply the configuration.
{{% /notice %}}
