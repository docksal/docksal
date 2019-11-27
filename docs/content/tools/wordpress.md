---
title: "Wordpress Settings"

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
