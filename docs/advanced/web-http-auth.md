# HTTP Basic Authentication

Modify your `.docksal/docksal.yml` or `.docksal/docksal-local.yml`.

Add following lines to `environment` section of `services: web` description and run `fin up` to apply changes.

```
environment:
  - APACHE_BASIC_AUTH_USER=user
  - APACHE_BASIC_AUTH_PASS=password
```
