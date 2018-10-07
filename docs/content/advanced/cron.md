---
title: "Running Cron"
---


{{% notice note %}}
Currently, custom crontab files are only supported within the `cli` container.
{{% /notice %}}

## Crontab file Explained

A crontab file has six fields for specifying minute, hour, day of month, month, day of week, and the command to be run at that interval. See below:

```bash
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

Cron can be started within a project by creating a `crontab` file within the projects `.docksal/services/cli` folder.
Once that file has been created or modified, the `cli` container should be restarted by running `fin restart cli`.
