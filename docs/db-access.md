# MySQL DB access for external tools

The MySQL service in the `db` container is exposed at a random port by default.
This is done to avoid port conflicts when running multiple Docksal powered projects (multisites don't count).

To view the randomly assigned port value run `fin config` and look for `MYSQL_PORT:`.
You can connect to MySQL in the db container on `192.168.64.100:<random-port-value>`.
Keep in mind, the random port value will change every time the `db` container is restarted.

## Assigning a static port

To have a static port assigned, override the `MYSQL_PORT_MAPPING` variable value in `.docksal/docksal-local.env`.

Replace `<unique-static-port>` with a **unique** port number (unique across all Docksal powered projects on your host).

```
MYSQL_PORT_MAPPING='<unique-static-port>:3306'
```

## Examples

**Project 1**

```
MYSQL_PORT_MAPPING='33061:3306'
```

MySQL endpoint: `192.168.64.100:33061`

**Project 2**

```
MYSQL_PORT_MAPPING='33062:3306'
```

MySQL endpoint: `192.168.64.100:33062`

## Credentials

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
