# MySQL DB access for external tools

MySQL port is not exposed in the `db` container by default.
This is done to avoid port conflicts if running multiple Docksal powered projects (multisites don't count).

Add the following lines in the `db` service definition in `docker-compose.yml` to make port **3306** exposed:

    ports:
      - "3306:3306"

Run `fin up`.

You will now be able to connect to MySQL in the db container on `192.168.10.10:3306`

Please keep in mind that two db containers will not be able to use the same port (`3306`) on the host.  
To avoid port conflicts with multiple Docksal powered projects give each project a unique port assignments.

**Project 1**

    # DB node
    db:
      ...
      ports:
        - "3306:3306"
      ...

MySQL endpoint: `192.168.10.10:3306`

**Project 2**

    # DB node
    db:
      ...
      ports:
        - "3307:3306"
      ...

MySQL endpoint: `192.168.10.10:3307`

When connecting to the MySQL DB using external tools use the following credentials:

    Username: admin
    Password: admin123 (or MYSQL_ROOT_PASSWORD variable in docker-compose.yml)
