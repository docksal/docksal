---
title: "MySQL DB access for external tools"
---


The MySQL service in the `db` container is exposed at a random port by default.
This is done to avoid port conflicts when running several Docksal projects at once.

```
$ fin vm ip
192.168.64.100
$ fin ps
        Name                      Command               State            Ports
---------------------------------------------------------------------------------------
sitename_cli_1   /opt/startup.sh gosu root  ...   Up      22/tcp, 9000/tcp
sitename_db_1    /entrypoint.sh mysqld            Up      0.0.0.0:34567->3306/tcp
sitename_web_1   /opt/startup.sh apache2 -D ...   Up      443/tcp, 80/tcp
```

Use the IP for host and the sitename_db_1 port (in this case, `34567`, but it's unique for every site) for port, and then the username and password you've configured (`user`/`user` by default).

It should look like this:

![macOS DNS settings](/images/db-access-sqlpro.png)

## Assigning a static port

To have a static port assigned, override the `MYSQL_PORT_MAPPING` variable value in `.docksal/docksal-local.env`.

### Example

```
MYSQL_PORT_MAPPING='33061:3306'
```

In this case current project db will be accessible at `192.168.64.100:33061`.

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

Override the default admin password by changing the value of `MYSQL_ROOT_PASSWORD` in `.docksal/docksal.env` or `.docksal/docksal-local.env`.

```
MYSQL_ROOT_PASSWORD="gue$$-me-not"
```
