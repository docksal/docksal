---
title: "Multiple Web Servers"
---

For projects that need multiple web servers but need to stay in the same Docksal project (e.g., headless/decoupled 
applications with frontend and backend hosted separately), you have a few options available. 


## Extra Virtual Host

Use the primary web container and add a separate virtual host. See web container [configuration overrides](/service/web/settings/).

All subdomains of your project (`*.project.docksal`) are automatically routed to the primary `web` container. 
Using a subdomain for the extra virtual host is the most straightforward approach. 

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

You can add `Include conf/extra/includes/host.conf` at the top of of the `<VirtualHost>` to include the boilerplate configuration of the main virtual host.
This includes setting up the virtual host to run PHP and proxy through to the `cli` container.

```
<VirtualHost *:80>
    Include conf/extra/includes/host.conf
    ...
</VirtualHost>
```

To route an additional custom domain to the primary `web` container, [see vhost-proxy docs](/core/system-vhost-proxy/#custom-domains). 


## Secondary Web Service

Define a secondary web service in your project's `docksal.yml` file:

Apache:

```yaml
services:
  ...
  styleguide:
    image: docksal/apache:2.4-2.5
    volumes:
      - project_root:/var/www:ro,nocopy,cached
    environment:
      - APACHE_DOCUMENTROOT=/var/www/styleguide
    labels:
      - io.docksal.virtual-host=styleguide.${VIRTUAL_HOST}
```

Nginx:

```yaml
services:
  ...
  styleguide:
    image: docksal/nginx:1.20-1.2
    volumes:
      - project_root:/var/www:ro,nocopy,cached
    environment:
      - NGINX_VHOST_PRESET=html
      - NGINX_SERVER_ROOT=/var/www/styleguide
    labels:
      - io.docksal.virtual-host=styleguide.${VIRTUAL_HOST}
```
