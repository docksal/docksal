---
title: "web: Basic HTTP Authentication"
aliases:
  - /en/master/advanced/web-http-auth/
---


If using the default stacks, add the following two lines in `docksal.env` or `docksal-local.env`.

**Apache**

```bash
APACHE_BASIC_AUTH_USER=user
APACHE_BASIC_AUTH_PASS=password
```

**Nginx**

```bash
NGINX_BASIC_AUTH_USER=user
NGINX_BASIC_AUTH_PASS=password
```

If using custom configuration, modify your `.docksal/docksal.yml` or `.docksal/docksal-local.yml`.  
Add the following two lines to the `web` service and run `fin project start` to apply changes:

**Apache**

```yaml
  web:
    ...
    environment:
      ..
      - APACHE_BASIC_AUTH_USER=user
      - APACHE_BASIC_AUTH_PASS=password
      ...
```

**Nginx**

```yaml
  web:
    ...
    environment:
      ..
      - NGINX_BASIC_AUTH_USER=user
      - NGINX_BASIC_AUTH_PASS=password
      ...
```
