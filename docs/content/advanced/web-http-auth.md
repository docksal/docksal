---
title: "Web server: HTTP Basic Authentication"
---


If using the default stacks, add the following two lines in `docksal.env` or `docksal-local.env`:

```bash
APACHE_BASIC_AUTH_USER=user
APACHE_BASIC_AUTH_PASS=password

```

If using custom configuration, modify your `.docksal/docksal.yml` or `.docksal/docksal-local.yml`.  
Add following two lines to for the `web` service and run `fin project start` to apply changes:

```yaml
  web:
    ...
    environment:
      ..
      - APACHE_BASIC_AUTH_USER=user
      - APACHE_BASIC_AUTH_PASS=password
      ...
```
