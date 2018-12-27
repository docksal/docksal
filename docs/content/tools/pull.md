---
title: "Pull"
aliases:
  - /en/master/tools/pull/
---

To quickly integrate into your hosting environment Docksal as the
`pull` command. What this allows is that you can easily bring your
assets (db, files, and code) down to your local environment quickly
without manually running through the steps.

## Integrated Hosting Providers

The `cli` image comes with the tools used for interacting with various
hosting providers. This allows for us to quickly get information from the
provider's account.

### Acquia ( `acquia` )

To interact with Acquia through Drush. The `SECRET_ACAPI_EMAIL` and
`SECRET_ACAPI_KEY` are required. Additionally, access to the Acquia Cloud API
is required. If access is not allowed fallback to using the Drush method.

More information on working with [Docksal with Acquia Drush](/tools/acquia-drush).

### Pantheon ( `pantheon` )

Interacting with Platform.sh requires that the `SECRET_TERMINUS_TOKEN`
is set. More information on [generating tokens](https://pantheon.io/docs/machine-tokens/)
can be found in Pantheon's documentation.

More information on working with [Docksal with Pantheon](/tools/pantheon).

### Platform.sh ( `platformsh` )

Interacting with Platform.sh requires that the `SECRET_PLATFORMSH_CLI_TOKEN`
is set. More information on [creating CLI tokens](https://docs.platform.sh/gettingstarted/cli/api-tokens.html)
for use with the Platform.sh CLI tool consult with Platform's documentation.

More information on working with [Docksal with Platform.sh](/tools/platformsh).

## Alternatives

If your project is hosted on another provider that isn't in the previously
listed group. Don't worry most Drupal and WordPress sites can be accessed
by using their respective aliases.

### Drupal / Drush ( `drush` )

The following is an example of `example.aliases.drushrc.php` .
```php
<?php

$aliases['dev'] = array(
  'remote-host' => 'server.domain.com',
  'remote-user' => 'www-admin',
  'root' => '/other/path/to/drupal',
  'uri' => 'http://example.com',
);
```

When configuring your project to interact the following commands can be ran.

```bash
fin config set --HOSTING_PROVIDER=drush
fin config set --HOSTING_SITE="example"
fin config set --HOSTING_ENV="dev"
```

{{% notice note %}}
For more information on setting up a [drush 8.x alias](http://api.drush.org/api/drush/examples%21example.aliases.drushrc.php/master)
take a look and can usually be set up as easily as adding a `example.aliases.drushrc.php`
to your project root.

To set up [drush 9.x alias](https://github.com/drush-ops/drush/blob/master/examples/example.site.yml).
{{% /notice %}}

More information on working with [Docksal and Drush](/tools/drush).

### WordPress / WP-CLI ( `wp` )

An example `wp-cli.yml` file would like like the following.

```yaml
@staging:
    ssh: wpcli@staging.wp-cli.org
    user: wpcli
    path: /srv/www/staging.wp-cli.org
```

When configuring your project to interact the following commands can be ran.

```bash
fin config set --HOSTING_PROVIDER=wp
fin config set --HOSTING_SITE="staging"
```

{{% notice note %}}
For more information on setting up a [wp-cli.yml alias](https://make.wordpress.org/cli/handbook/config/#config-files)
take a look and can usually be set up as easily as adding a `wp-config.yml`
to your project root.
{{% /notice %}}

More information on working with [Docksal and WP-CLI](/tools/wp).

## Commands

The following commands will allow for quickly grabbing data from a
hosting provider and should allow for an easier development experience.

### Help

For more information on the `pull` command including arguments and options
use the `help` command to get more details.

```bash
fin help pull
```

### Initialize

Starting from a provider is easy and sometimes requires a simple `git pull`
but other times it requires a much lengthier process. Logging into the
provider and downloading files or database.

```bash
fin pull init \
    --HOSTING_PLATFORM=<platform> \
    --HOSTING_SITE=<site> \
    --HOSTING_ENV=<env> \
    <directory_name>
```

** NOTE **

{{% notice note %}}
Drupal and WordPress Providers are supported but require a GIT URL that
can be cloned.

An example of this would be

```bash
fin pull init \
    --HOSTING_PLATFORM=drush \
    --HOSTING_SITE="example" \
    --HOSTING_ENV="drush \
    my_new_site \
    https://github.com/docksal/drupal8.git
```
{{% /notice %}}

### Code

Pulling code is simple as running the `fin pull code` command. This executes
a `git pull` on the code. If for any other reason there is a need to pull
from a different remote or branches they can be specified using the
`SYNC_GIT_REMOTE` and `SYNC_GIT_BRANCH` options. If neither are supplied
then `SYNC_GIT_REMOTE` defaults to `origin` and `SYNC_GIT_BRANCH` defaults
to the current branch.

```bash
fin pull code \
    --SYNC_GIT_REMOTE=<remote> \
    --SYNC_GIT_BRANCH=<branch>
```

### Database

Pulling the database is as simple as running the `fin pull db` command.

```bash
fin pull db \
    --DBNAME=<dbname> \
    --DBUSER=<dbuser> \
    --DBPASS=<dbpass> \
    --FORCE \
    <remote_database_name>
```

### Files

Pulling down the files from an environment can sometimes be lengthy. Especially
if you only want new files or updated files. Using the `rsync` command
can be especially great because it can help you with that process, but
what about trying to remember the `rsync` command and options you need for
the files to pull specifically can be a pain.

```bash
fin pull files
```

### All

When no options are provided `fin pull` will run through all items
(code, db, and files) and pull from the provided hosting environment.
All of the arguments will be passed through to the appropriate assets.

```bash
fin pull
```
