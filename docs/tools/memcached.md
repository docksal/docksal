# Enable Memcached support

Add the `memcached` service under the `services` section in `.docksal/docksal.yml`

There are two options to do this: basic, advanced.

**Basic**

Extends from Docksal's services library (`services.yml`).  
This option is recommended for most users.  
It ensures your project will get updates for the service when they are released.

```yaml
  # Memcached
  memcached:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: memcached
```

**Advanced** 

Defines service configuration in full and does not inherit settings from Docksal's services library (`services.yml`).  
This option is recommended for advanced users.  
Use it when maintaining a static stack configuration, that is fully defined in the project's `docksal.yml` file.  


```yaml
  # Memcached
  memcached:
    hostname: memcached
    image: memcached:1.4-alpine
    # Set memcached memory limit to 128 MB by default
    command: ["-m", "128"]
    dns:
      - ${DOCKSAL_DNS1}
      - ${DOCKSAL_DNS2}
```

Apply new configuration with `fin project start` (`fin p start`).

Use `memcached:11211` as the memcached endpoint.


## Overriding default settings

By default, memcached will be started with 128MB memory allocation.  
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
