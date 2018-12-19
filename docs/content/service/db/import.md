---
title: "Automatic database import"
aliases:
  - /en/master/advanced/db-import/
---


The `mysql` service container can perform an automatic import of the database dump upon initialization.

## Setup

Create a folder for the database dumps inside the project root called `db` (name can differ).

Add `*.sql` or `*.sql.gz` file(s) into the newly created `db` folder.

{{% notice note %}}
You can add multiple *.sql and *.sql.gz files. All files will be imported in alphabetical order. 
The `MYSQL_DATABASE` variable contains the active database.
{{% /notice %}}

Add to the `mysql` service in the project's `.docksal/docksal.yml` file as follows:

```yaml
mysql:
  ...
  volumes:
    - ${PROJECT_ROOT}/db:/docker-entrypoint-initdb.d:ro
  ...
```

Run `fin project reset mysql` (`fin p reset mysql`) to reinitialize the `mysql` service.

It may take some time for the database server to initialize and import the dump.  
Check container logs for progress and/or issues if necessary (`fin logs mysql`).
