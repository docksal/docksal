# Automatic database dump import on container create.

Docksal MySQL container allow to automatically import database dump on container create. To use it project should have configuration (`.docksal/docksal.env` and `.docksal/docksal.yml`). If it doesn't exist, use `fin config generate` to generate it.

# Setup

1. Create folder for database dump `${PROJECT_ROOT}/db`.

2. Place `*.sql` or `*.sql.gz` dump file to `${PROJECT_ROOT}/db` folder. NOTE: Container will import all `*.sql` and `*.sql.gz` files in alphabetical order into `MYSQL_DATABASE` database.

3. Add the following configuration option to the `db` service in the project's `.docksal/docksal.yml` file:

    ```yml
    db:
      ...
      volumes:
        - ${PROJECT_ROOT}/db:/docker-entrypoint-initdb.d:ro
      ...
    ```

4. Reset the db container `fin reset db`.
