---
title: "Wordpress settings"

---

Below you will find instructions on configuring your Wordpress project to work with Docksal.
Some settings are required; others are optional or enhancements. Please review carefully.

## DB Connection Settings (**required**) {#db}

This command needs to run prior to running `wp core install`:

```
wp core config --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=db
```

## User Settings

Add your user variables to the `.docksal/docksal.env` file:

```
# Wordpress settings
WP_ADMIN_USER=admin
WP_ADMIN_PASS=admin
WP_ADMIN_EMAIL=info@example.com
```

