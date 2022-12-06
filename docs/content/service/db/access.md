---
title: "db: Access for External Tools"
aliases:
  - /en/master/advanced/db-access/
---


The MySQL service in the `db` container is exposed at a random port by default.
This is done to avoid port conflicts when running several Docksal projects at once.

```
$ fin ps
        Name                      Command               State            Ports
---------------------------------------------------------------------------------------
sitename_cli_1   /opt/startup.sh gosu root  ...   Up      22/tcp, 9000/tcp
sitename_db_1    /entrypoint.sh mysqld            Up      0.0.0.0:34567->3306/tcp
sitename_web_1   /opt/startup.sh apache2 -D ...   Up      443/tcp, 80/tcp
```

Use the IP `192.168.64.100` for host and the sitename_db_1 port (in this case, `34567`, but it's unique for every site) for port, and then the username and password you've configured (`user`/`user` by default).

It should look like this:

![sqlpro connection settings](/images/db-access-sqlpro.png)

## Assigning a static port

To have a static port assigned, override the `MYSQL_PORT_MAPPING` variable value in `.docksal/docksal-local.env`.

### Example

```
MYSQL_PORT_MAPPING='33061:3306'
```

In this case, the current project db will be accessible at `192.168.64.100:33061`.

{{% notice note %}}
If you plan to run several Docksal projects with exposed static ports at once, then use unique exposed port numbers.
{{% /notice %}}

## Credentials

Default user credentials:

```
Username: user
Password: user
```

Default admin credentials:

```
Username: root
Password: root
```

## Root password

Override the default admin password by changing the configuration value of `MYSQL_ROOT_PASSWORD` for project environment file or the local environment file.

```
fin config set MYSQL_ROOT_PASSWORD="gue$$-me-not"
```
or
```
fin config set --env=local MYSQL_ROOT_PASSWORD="gue$$-me-not"
```

{{% notice note %}}
You must run `fin reset db` after making a change to the MySQL passwords. This will drop your existing databases and require you to re-import your data.
{{% /notice %}}
