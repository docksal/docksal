---
title: "Apache settings"
---

The following settings files in the project codebase can be used to override default Apache settings.

Use `.docksal/etc/apache/httpd-vhost-overrides.conf` to override the default virtual host configuration:

```apacheconfig
DirectoryIndex index2.html
```

Use `.docksal/etc/apache/httpd-vhosts.conf` to define additional virtual hosts:

```apacheconfig
<VirtualHost *:80>
	ServerName docs.test.docksal

	ProxyPass / http://docs.docksal.io/
	ProxyPassReverse / http://docs.docksal.io/
</VirtualHost>
```
