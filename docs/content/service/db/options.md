---
title: "db: Service Options"
weight: 1
---

The default stack uses MySQL for the db service while the pantheon and platformsh stacks use MariaDB.
Docksal has also defined PostgreSQL as a db service option. You do not have to make any
configuration changes to use MySQL, but if you want to specify the use of MariaDB or PostgreSQL,
you will need to modify your `docksal.yml` file.

## MariaDB Configuration {#mariadb-config}

Docksal has defined a db service with a MariaDB image. To set your db service to use MariaDB
instead of MySQL, set the db service in your `docksal.yml` file.

```yaml
services:
  db:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: mariadb
```


## PostgreSQL Configuration {#postgresql-config}

Docksal has defined a db service with a PostgreSQL image. To set your db service to use PostgreSQL instead of MySQL,
set the db service in your `docksal.yml` file.

```yaml
services:
  db:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: pgsql
```

{{% notice note %}}
Remember to run `fin project start` (`fin p start`) to apply the configuration.
{{% /notice %}}

## Determining the db service type {#db-service-type}
The following order is used to determine which db service is currently being used

- If the `db` service has label `io.docksal.db-type` then the value of that label is used.
  Supported values are 
  - `mysql`
  - `postgres`
- The destination of the second `volumes` `target` for the `db` service is checked for `/postgresql/data` then the result is `postgres`.
- The default value of `mysql` is used if none of the above conditions are met.

This way there is much flexibility in the configuration of the `db` service.

`fin config` can be used to determine the second `volumes` `target` information

## PostgreSQL utility programs {#postgresql-utility-programs}
The following PostgreSQL utility programs are using by fin commands
- `psql` - the PostgreSQL command line client
- `createdb` - the PostgreSQL database creation utility
- `dropdb` - the PostgreSQL database deletion utility
- `pg_dump` - the PostgreSQL database dump utility
