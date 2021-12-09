---
title: "fin pull (hosting integrations)"
weight: 3
---

`pull` command allows you to easily bring your assets: db, files, and code from your hosting environment
down to your local environment without manually running through the steps.

## Requirements

### Acquia

To interact with Acquia through Drush, the `SECRET_ACQUIA_CLI_SECRET` and
`SECRET_ACQUIA_CLI_KEY` are required. Additionally, access to the Acquia Cloud API
is required. If access is not allowed, fallback to using the [Drush](/fin/fin-pull/#drupal-drush) method.

More information on working with [Docksal with Acquia Drush](/tools/acquia-drush).

### Pantheon

Interacting with Pantheon requires that the `SECRET_TERMINUS_TOKEN`
is set. More information on [generating tokens](https://pantheon.io/docs/machine-tokens/)
can be found in Pantheon's documentation.

More information on working with [Docksal with Pantheon](/tools/terminus).

### Platform.sh

Interacting with Platform.sh requires that the `SECRET_PLATFORMSH_CLI_TOKEN`
is set. For more information on [creating CLI tokens](https://docs.platform.sh/gettingstarted/cli/api-tokens.html)
for use with the Platform.sh CLI tool, consult with Platform's documentation.

More information on working with [Docksal with Platform.sh](/tools/platformsh).

### Drupal / Drush

A [Drush site alias](/tools/drush/#site-aliases) must be set up within the project and recognized when running the `fin drush sa` command to use 
the Drush provider integration. An example of a site alias file for [Drush 8](https://github.com/drush-ops/drush/blob/8.x/examples/example.aliases.drushrc.php), [Drush 9](https://github.com/drush-ops/drush/blob/9.x/examples/example.site.yml) and [Drush 10](https://github.com/drush-ops/drush/blob/master/examples/example.site.yml) can be
found within the Drush project.

An example of what `remote.site.yml` would look like:

```yaml
dev:
  host: 1.1.1.1
  paths:
    dump-dir: /home/remote-user/backup/
  root: /var/www/drupal8/docroot
  uri: example.com
  user: remote-user

```

The following is an example of `example.aliases.drushrc.php`:

```php
<?php

$aliases['dev'] = array(
  'remote-host' => 'server.domain.com',
  'remote-user' => 'www-admin',
  'root' => '/other/path/to/drupal',
  'uri' => 'http://example.com',
);
```

### WordPress / WP-CLI

To use the WP-CLI provider integration, an alias must be set up within the project. For instructions 
on setting up a `wp-cli.yml` file or a config file, consult the [WordPress WP-CLI Config Documentation](https://make.wordpress.org/cli/handbook/config/#config-files).

Example of what `wp-cli.yml` would look like:

```yaml
@remote:
  ssh: ssh-user@1.1.1.1/var/www/wordpress/docroot
  url: http://example.com
```

More information on working with [Docksal and WP-CLI](/tools/wp-cli).

## Initializing Project

If you are not using an initializing process for a specific provider and are
starting from an already existing project, you can take advantage of
the `fin pull` command by setting the `HOSTING_PLATFORM` and
`HOSTING_SITE` variables within the project's `.docksal/docksal.env`
file.

```bash
fin config set HOSTING_PLATFORM=[provider]

fin config set HOSTING_SITE="[remote name]"

# WordPress is the only provider that doesn't need to use this.
fin config set HOSTING_ENV="[remote env]"
```

If you are starting from scratch, the following command can be used
to pull code and start the project locally:

```bash
fin pull init \
    --hosting-platform=<platform> \
    --hosting-site=<site> \
    --hosting-env=<env> \
    <directory_name>
```

### Acquia / Pantheon / Platform.sh

Additionally, the `--hosting-env` option can be used to specify exactly
which environment on Acquia Cloud that should be used. If it isn't used, 
the `dev` environment is used by default.

### Drush / WP-CLI

Drupal and WordPress Providers are supported but require a GIT URL that
can be cloned.

```bash
fin pull init \
    --hosting-platform=drush \
    --hosting-site="example" \
    my_new_site \
    https://github.com/docksal/drupal8.git
```

## Pulling Code

Pulling code utilizes the project's existing git remotes and allows for
the project to pull in the latest code from the remote.

To pull code use the argument `code`. This will default to pulling `origin`
and then pulling the current branch. If a different branch or remote is required,
those can be specified using the flags `--sync-git-remote` and `--sync-git-branch`.

Example

```
# Default Pull From Origin and current branch.
fin pull code

# Pull from the production remote.
fin pull code --sync-git-remote=production

# Pull the dev branch.
fin pull code --sync-git-branch=dev

# Pull from the github remote and the rc branch.
fin pull code --sync-git-remote=github --sync-git-branch=rc
```

```
  --sync-git-remote             The GIT Remote to pull from. (Defaults to origin)
  --sync-git-branch             The GIT Branch to pull from. (Defaults to current branch)
```

## Pulling Database

To pull a database from the remote, run the `pull db` command. When
pulling the database, it stays cached within your `cli` container for a
period of one (1) hour. If at any point this needs to be updated, use
the `--force` option as this will bypass the database and reimport.

```bash
fin pull db
```

When pulling there are some additional options that can be used for
importing the data.

```
  --db-user=<user>               Specify the DB User (Defaults to root)
  --db-pass=<pass>               Specify the DB Password (Defaults to root)
  --db-name=<dbname>             Specify the DB Name to import into. (Defaults to default)
  --force                       Force a new database file to be pulled
  --remote-db=<remote_db>       Specify the remote DB name to pull. (Used with Acquia)
  --progress                    Show import progress
```

{{% notice note %}}
Acquia has the ability to host a Drupal multi-site which allow
multiple databases within the Acquia cloud that can be accessed. A
database can be pulled down using the `--remote-db` option where the
remote db is the database within the site's dashboard.
{{% /notice %}}

## Pulling Files

Pulling down the files from an environment can sometimes be a lengthy process, especially
if you only want new files or updated files. Using the `rsync` command can help you with 
that process, but trying to remember the `rsync` command and options you need for
the files to pull specifically can be challenging.

```bash
fin pull files
```

Additional options can be used to help rsync the files locally.

```
  --rsync-options=<options>     Rsync Options to append.
  --files-dir=<dir>             Directory to sync files with.
                                Default Drupal: {DOCROOT}/sites/default/files/
                                Wordpress Default: {DOCROOT}/wp-content/uploads/

```

{{% notice warning %}}
Due to limitations with WP-CLI, file syncing is not supported for `wordpress`
at this time. Please check back later as we are working on this feature.
{{% /notice %}}

## Pulling All

When no options are provided, `fin pull` will run through all items
(code, db, and files) and pull from the provided hosting environment.
All of the arguments will be passed through to the appropriate assets.

```bash
fin pull
```

## Help

For more information on the `pull` command, including arguments and options,
use the `help` command to get more details.

```bash
fin help pull
```
