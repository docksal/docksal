---
title: "Apache Settings"
aliases:
  - /en/master/advanced/web-configuration-overrides/
---

The following settings files in the project codebase can be used to override default Apache settings.

Use `.docksal/etc/apache/httpd-vhost-overrides.conf` to override the default virtual host configuration:

```apacheconfig
DirectoryIndex index2.html
```

Use `.docksal/etc/apache/httpd-vhosts.conf` to define additional virtual hosts:

```apacheconfig
<VirtualHost *:80>
    ServerName ${APACHE_SERVERNAME}
    ServerAlias styleguide.*
    DocumentRoot /var/www/styleguide
</VirtualHost>

<Directory "/var/www/styleguide">
    Require all granted
</Directory>
```

## Using Different Apache Versions {#apache-versions}

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `WEB_IMAGE` variable in `.docksal/docksal.env`, e.g.:

```bash
WEB_IMAGE='docksal/web:2.1-apache2.2'
```
This can also be set with `fin config set`.
```bash
fin config set WEB_IMAGE='docksal/web:2.1-apache2.2'
```
Remember to run `fin project restart web` (`fin p restart web`) to apply the configuration.

Available images:

- Apache 2.2 - `docksal/web:2.1-apache2.2`
- Apache 2.4 - `docksal/web:2.1-apache2.4` (default)

There are also "edge" versions available that contain code from ongoing updates, but may not be stable. Don't switch to an
edge image unless directed to do so by the Docksal team for testing purposes only.

See documentation for projects using a [custom stack configuration](/stack/custom-configuration/).
