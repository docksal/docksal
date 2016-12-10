# Automatic database import

The `db` service container can perform automatic database dump import when initialized.

# Setup

### 1. Create a folder for database dumps

Create a folder for database dumps inside the project root called `db` (name can differ).

### 2. Place `*.sql` or `*.sql.gz` file(s) into the `db` folder.

!!! note You can put multiple `*.sql` and `*.sql.gz` files.
They will all be imported in an alphabetical order.
Database set in `MYSQL_DATABASE` variable is used.

### 3. Add the following configuration

Add the following to `db` service in the project's `docksal.yml` file:

```yml
db:
  ...
  volumes:
    - ${PROJECT_ROOT}/db:/docker-entrypoint-initdb.d:ro
  ...
```

### 4. Re-create containers

Run `fin reset`
