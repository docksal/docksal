!!! danger Do not follow this instruction on Windows. 
    It does not work properly on windows and will break your setup. We are working and getting it updated.

# Automatic database import

The `db` service container can perform an automatic import of the database dump upon initialization.

# Setting up

#### 1. Create a folder for database dumps

Create a folder for database dumps inside the project root called `db` (name can differ).

#### 2. Add `*.sql` or `*.sql.gz` file(s) into the newly created `db` folder.

!!! note "You can add multiple *.sql and *.sql.gz files"
    All files will be imported in alphabetical order. The `MYSQL_DATABASE` variable contains the active database.

#### 3. Add the following configuration

Add to the `db` service in the project's `docksal.yml` file as follows:

```yml
db:
  ...
  volumes:
    - ${PROJECT_ROOT}/db:/docker-entrypoint-initdb.d:ro
  ...
```

#### 4. Re-create containers

Run `fin reset`
