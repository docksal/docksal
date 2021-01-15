---
title: "Wordpress Settings"
aliases:
  - /en/master/advanced/drupal-settings/
  - /tools/wordpress/
---

Below you will find instructions on configuring your WordPress project to work with Docksal.

## DB Connection Settings {#db}

Update the DB settings in `wp-config.php` as follows:

```php
define( 'DB_NAME', getenv('MYSQL_DATABASE') );
define( 'DB_USER', getenv('MYSQL_USER') );
define( 'DB_PASSWORD', getenv('MYSQL_PASSWORD') );
define( 'DB_HOST', getenv('MYSQL_HOST') );
```

## Using HTTPS {#https}

Docksal uses a [reverse proxy](/core/system-vhost-proxy/), which terminates HTTPS connections and passes the connection 
on to projects in plain HTTP. In such setups, WordPress does not know out of the box when it's loaded over HTTPS.

To help WordPress detect when it's loaded over HTTPS, add the following lines **at the top** of your `wp-config.php`:

```php
// Pass "https" protocol from reverse proxies
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https') {
  $_SERVER['HTTPS'] = 'on';
}
```

Then, change the site URL protocol either via admin UI under Settings > General, or via `wp-config.php`:

```php
// Set site URL (or update this in Settings/General in admin UI)
define( 'WP_HOME', 'https://wordpress.docksal.site/' );
define( 'WP_SITEURL', 'https://wordpress.docksal.site/' );
```

## Multisite Settings {#multisite}

When converting a single site to a multi-site, there can be some issues that occur with 
redirect loops. Make sure to update the `.htaccess` instructions found on the WordPress.org
site. [Htaccess settings for WordPress multisite](https://wordpress.org/support/article/htaccess/#multisite).
