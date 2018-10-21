---
title: "Automatic database import"
---


The `db` service container can perform an automatic import of the database dump upon initialization.

## Setup

Create a folder for the database dumps inside the project root called `db` (name can differ).

Add `*.sql` or `*.sql.gz` file(s) into the newly created `db` folder.

{{% notice note %}}
You can add multiple *.sql and *.sql.gz files. All files will be imported in alphabetical order. 
The `MYSQL_DATABASE` variable contains the active database.
{{% /notice %}}

Add to the `db` service in the project's `.docksal/docksal.yml` file as follows:

```yaml
db:
  ...
  volumes:
    - ${PROJECT_ROOT}/db:/docker-entrypoint-initdb.d:ro
  ...
```

Run `fin project reset db` (`fin p reset db`) to reinitialize the `db` service.

It may take some time for the database server to initialize and import the dump.  
Check container logs for progress and/or issues if necessary (`fin logs db`).
