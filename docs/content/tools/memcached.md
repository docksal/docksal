---
title: "Memcached"
---


Add the `memcached` service under the `services` section in `.docksal/docksal.yml`:

```yaml
  # Memcached
  memcached:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: memcached
```

Use `memcached:11211` as the memcached endpoint.

Complete `memcached` service definition can be found in `$HOME/.docksal/stacks/services.yml`.


## Overriding default settings

By default, memcached will be started with `128MB` memory allocation.  
This can be overridden via the command arguments in the service definition.

```yaml
  # Memcached
  memcached:
    ...
    # Set memcached memory limit to 128 MB by default
    command: ["-m", "128"]
    ...
```
Add and adjust as necessary in `docksal.yml`. Apply new configuration with `fin project start` (`fin p start`).
