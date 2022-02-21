---
title: "web: Settings"
aliases:
  - /en/master/advanced/web-configuration-overrides/
---

### Apache Advanced Settings {#apache-settings}

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

For a complete list of available features and settings see [docksal/service-apache](https://github.com/docksal/service-apache).


### Nginx Advanced Settings {#nginx-settings}

The following settings files in the project codebase can be used to override default Nginx settings.


Use `.docksal/etc/nginx/vhost-overrides.conf` to override the default virtual host configuration:

```
  index index2.html;
```

Use `.docksal/etc/nginx/vhosts.conf` to define additional virtual hosts:

```
server
{
    listen 80;
    server_name test3.docksal;
    root /var/www/docroot;
    index index3.html;
}
```

For a complete list of available features and settings see [docksal/service-nginx](https://github.com/docksal/service-nginx).


### Using Different Versions {#versions}

When using the default stack (a custom project stack is not defined in `.docksal/docksal.yml`), switching can be done 
via the `WEB_IMAGE` variable in `.docksal/docksal.env`, e.g.:

```bash
WEB_IMAGE='docksal/apache:2.4-2.4'
```

This can also be set with `fin config set`.

```bash
fin config set WEB_IMAGE='docksal/apache:2.4-2.4'
```

Remember to run `fin project restart web` (`fin p restart web`) to apply the configuration.

Use the following commands to get the list of available Apache and Nginx images:

```bash
fin image registry docksal/apache
fin image registry docksal/nginx
```

{{% notice warning %}}
Use `WEB_IMAGE` to only switch between version (tags) of the same image. 
Switching between Apache and Nginx cannot be done using this approach, since the two services have different 
configuration variables.
{{% /notice %}}
