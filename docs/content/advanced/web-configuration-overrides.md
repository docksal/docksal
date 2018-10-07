---
title: "Web server: Configuration overrides"
---



Configuration overrides can be added to a Docksal project codebase.

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
