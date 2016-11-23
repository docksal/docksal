# MySQL DB access for external tools

MySQL service in the `db` container is exposed at a random port by default.
This is done to avoid port conflicts if running multiple Docksal powered projects (multisites don't count).

To view the randomly assigned port value run `fin config` and look for `MYSQL_PORT:`.  
You can connect to MySQL in the db container on `192.168.64.100:<random-port-value>`.  
Keep in mind, that the random port value will change every time the DB container is restarted.

To have a static port assigned, put this line into `.docksal/docksal-local.env` file 
and set '<host-port>' to a **unique** port number (unique across all Docksal powered projects on your host): 

```
MYSQL_PORT='<host-port>:3306'
```

Examples

**Project 1**

```
MYSQL_PORT='33061:3306'
```

MySQL endpoint: `192.168.64.100:33061`

**Project 2**

```
MYSQL_PORT='33062:3306'
```

MySQL endpoint: `192.168.64.100:33062`

When connecting to the MySQL DB using external tools use the following credentials:

```
Username: admin
Password: root (or `MYSQL_ROOT_PASSWORD` variable in `.docksal/docksal.env`)
```
