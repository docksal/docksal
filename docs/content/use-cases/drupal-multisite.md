---
title: "Drupal Multisite"
weight: 1
---

Drupal allows separate, independent sites to be served from a single codebase where each site has its own 
database, configuration, public files folder, and base domain or URL. See [Drupal documentation](https://www.drupal.org/docs/8/multisite) 
for general documentation on Drupal multisites.

Follow these steps to setup multisite on Docksal:

## Create a Database

A `default` database is created with every project that uses the `default` stack, but each multisite requires its own database.
Therefore, you will need to create the database in the container for each multisite that is not the default site.

```bash
fin db create 'anothersite'
```

## Create a Site Directory for the New Site

Each site has its own directory under `docroot/sites` that should contain a `settings.php` file where you have the settings 
for your live site. You should also have a `local.settings.php` file that includes settings for the local copy of your
site. `settings.php` should detect and include `local.settings.php`.

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

## Add to sites.php

Sub-site domains must be defined in the `sites.php` file for Drupal to redirect its URLs to it. Add the following line
to your `sites.php` file, and replace `myproject` with your Docksal project name.

```php
$sites['anothersite.myproject.docksal'] = 'anothersite';
```
Your site will then be accessible through `http://anothersite.myproject.docksal` (substitute your project URL).

You can look at the [Drupal 7 advanced boilerplate project](https://github.com/docksal/boilerplate-drupal7-advanced) to see an example.

{{% notice note %}}
This page covers how to use the default domain settings in Docksal. It is possible to use arbitrary custom 
domains in Docksal. Please refer to the documentation on [virtual host proxy](/core/system-vhost-proxy/#using-arbitrary-custom-domains)
for how to use arbitrary domains in Docksal projects.
{{% /notice %}}
