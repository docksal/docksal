---
title: "cli: Scheduled Jobs (cron)"
aliases:
  - /en/master/advanced/cron/
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

By default, cron runs commands through `/bin/sh` and can sometimes cause issues when trying to run commands that are 
found within the `$PATH`. One recommendation is to wrap the commands in `bash -l -c` so that the profile can load. An 
example of this would be using drush to run cron on a drupal website.

```bash
* * * * * bash -l -c 'drush --root=/var/www/docroot core:cron'
```

## Configuring Cron

Cron can be started within a project by creating a `crontab` file within the projects `.docksal/services/cli` folder.
Once that file has been created or modified, the `cli` container should be restarted by running `fin restart cli`.
