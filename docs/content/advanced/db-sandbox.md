---
title: "Database sandbox mode (snapshots)"
---


In certain cases, you may want to have a DB sandbox, mess around with it, then roll it back.
This can usually be achieved by backing up the DB and then restoring it from the backup.
With large databases (over 500MB), this operation can take a considerable amount of time (10+ minutes).

With Docker, we can create a snapshot image of the DB container. 
Spinning up such image takes less time than re-importing the DB with MySQL.

For example, a 2.6GB DB dump file takes 14 minutes to import with MySQL. 
(Re)launching a docker container from an image with that same DB dump takes only 2 minutes.

**Your results may obviously vary.**

## Enabling sandbox mode

1) Backup the database: `fin sqld db.sql`  
2) Update the `db` service in `docksal.yml` as follows: 

```yaml
db:
  ...
  command: "--datadir /var/lib/mysql-sandbox"
```

3) Reset the db service: `fin project reset db` 
4) Import the database: `fin sqli db.sql`  
5) Create a snapshot image from the `db` container:

```bash
fin project stop
fin docker commit $(fin docker-compose ps -q db) <tag>
```

Replace `<tag>` with any meaningful tag you'd like to use for the image, e.g., `db_backup` or `dbdata/myproject:snapshot1`.

6) Update the `db` service in `docksal.yml` as follows:

```yaml
db:
  ...
  image: <tag>
  command: "--datadir /var/lib/mysql-sandbox"
```

7) Update the stack configuration: `fin project start` (`fin p start` for short)

Now the `db` service container is using an ephemeral storage for the database (changes) - `/var/lib/mysql-sandbox`.

To reset it to the snapshot you took in step 1 run `fin project reset db` (`fin p reset db`).

## Disabling sandbox mode

You will need a DB dump to revert.
Either use the one created before enabling the sandbox mode or create a new one.

1) Revert the changes done to the `db` service in `docksal.yml` 
2) Reset the `db` service: `fin project reset db` 
3) Import the DB dump

Now the `db` service container is using a persistent storage volume for the database - `/var/lib/mysql`.

{{% notice warning %}}
With large databases, it is not recommended to snapshot a container that is already running off of a snapshot image.  
Every docker image holds all parent images plus in-memory changes inside it. 
With every commit the size of the resulting image will increase by the full size of the DB, not just the delta.
{{% /notice %}}