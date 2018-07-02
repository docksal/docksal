# Running Cron

!!! note "CLI Container"
	Currently custom crontab files are only supported within the `cli` container.

## Crontab file Explained

A crontab file has six fields for specifying minute, hour, day of month, month, day of week and the command to be run at that interval. See below:

```
*     *     *     *     *  command to be executed
-     -     -     -     -
|     |     |     |     |
|     |     |     |     +----- day of week (0 - 6) (Sunday=0)
|     |     |     +------- month (1 - 12)
|     |     +--------- day of month (1 - 31)
|     +----------- hour (0 - 23)
+------------- min (0 - 59)
```

## Configuring Cron

Cron can be started within a project by creating a `crontab` file within the projects `.docksal/etc/services/cli` folder.
Once that file has been created the `cli` container should be restarted `fin restart cli` and cron should be initialized.
Additionally the `fin cron reload` command can also be ran to reload and initialize the cron file. The same command can
be used if there are changes within the cron file and the file needs to be reloaded.