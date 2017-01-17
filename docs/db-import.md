!!! danger Do not follow this instruction on Windows. 
    It does not work properly on windows and will break your setup. We are working and getting it updated.

# Automatic database import

The `db` service container can perform an automatic import of the database dump upon initialization.

## Setup

Create a folder for database dumps inside the project root called `db` (name can differ).

Add `*.sql` or `*.sql.gz` file(s) into the newly created `db` folder.

!!! note "You can add multiple *.sql and *.sql.gz files"
    All files will be imported in alphabetical order. The `MYSQL_DATABASE` variable contains the active database.

Add to the `db` service in the project's `docksal.yml` file as follows:

```yml
db:
  ...
  volumes:
    - ${PROJECT_ROOT}/db:/docker-entrypoint-initdb.d:ro
  ...
```

Run `fin reset` to reset containers.
