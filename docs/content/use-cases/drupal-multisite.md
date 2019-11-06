---
title: "Drupal Multisite"
weight: 1
---

>Drupal has a feature which allows separate, independent sites to be served from a single codebase. Each site has its own 
database, configuration, files and base domain or URL.

See [Drupal documentation](https://www.drupal.org/docs/8/multisite) for general documentation on Drupal multisites.

Follow these steps to setup multisite on Docksal:

### Create a Database

A `default` database is created with every project that uses the `default` stack, but each multisite requires its own database.
Therefore, you will need to create the database in the container for each multisite that is not the default site.

```bash
fin db create 'anothersite'
```

### Create a Site Directory for the New Site

Each site has its own directory with a settings.php file. You will have the settings for your live site in there and you 
should have a `local.settings.php` file where you include local settings. Your `settings.php` file should detect and include
the local file.

```php
$databases = [
  'default' =>
  [
    'default' =>
    [
      'database' => 'anothersite',
      'username' => 'user',
      'password' => 'user',
      'host' => 'db',
      'port' => '3306',
      'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
      'driver' => 'mysql',
      'prefix' => '',
    ],
  ],
];
```

### Add to sites.php

For Drupal to direct a domain to a defined multisite, it must be defined in the `sites.php` file. Add the following line
to your `sites.php` file and replace `myproject` with your Docksal project name.

```php
$sites['anothersite.myproject.docksal'] = 'anothersite';
```
{{% notice note %}}
This page covers how to use the default domain settings in Docksal. It is possible to use arbitrary custom 
domains in Docksal. Please refer to the documentation on [virtual host proxy](/core/system-vhost-proxy/#using-arbitrary-custom-domains)
for how to use arbitrary domains in Docksal projects.
{{% /notice %}}
