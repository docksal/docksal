# MySQL DB access for external tools

!!! warning "This documentation is outdated"
    Instructions in this document need to be updated

MySQL service in the `db` container is exposed at a random port by default.
This is done to avoid port conflicts when running multiple Docksal powered projects (multisites don't count).

To view the randomly assigned port value run `fin config` and look for `MYSQL_PORT`.  
You can connect to MySQL in the `db` container on `192.168.64.100:<random-port-value>`.  
Keep in mind, that the random port value will change every time the `db` container is restarted.

## Assigning static port

To have a static port assigned, add the following line in `.docksal/docksal.env` or `.docksal/docksal-local.env`:

```
MYSQL_PORT_MAPPING='<unique-static-port>:3306'
```

Replace `<unique-static-port>` with a **unique** port number (unique across all Docksal powered projects on your host):

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

To override the default admin password, add the following line in `.docksal/docksal.env` or `.docksal/docksal-local.env`

```
MYSQL_ROOT_PASSWORD="gue$$-me-not"
```
