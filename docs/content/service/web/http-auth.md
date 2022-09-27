---
title: "web: Basic HTTP Authentication"
aliases:
  - /en/master/advanced/web-http-auth/
---


If using the default stacks, run these commands (add `--env=local` to add to the `docksal-local.env` file):

**Apache**

```bash
fin config set APACHE_BASIC_AUTH_USER=user
fin config set APACHE_BASIC_AUTH_PASS=password
```

**Nginx**

```bash
fin config set NGINX_BASIC_AUTH_USER=user
fin config set NGINX_BASIC_AUTH_PASS=password
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
