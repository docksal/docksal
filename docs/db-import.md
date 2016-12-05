# Automatic database import

The `db` service container can perform automatic database dump import when initialized.

# Setup

1) Create a folder for database dump(s), e.g. `db` in the project root. 

2) Place `*.sql` or `*.sql.gz` file(s) into the `db` folder.

    NOTE: You can put multiple `*.sql` and `*.sql.gz` files.
    They all will be imported in an alphabetical order.  
    `MYSQL_DATABASE` database is used by default and cannot be changed. 

3) Add the following configuration option to the `db` service in the project's `.docksal/docksal.yml` file:

    ```yml
    db:
      ...
      volumes:
        - ${PROJECT_ROOT}/db:/docker-entrypoint-initdb.d:ro
      ...
    ```

4) Reset the db container: `fin reset db`
