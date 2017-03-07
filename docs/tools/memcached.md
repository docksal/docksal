# Enable Memcached support

Add the `memcached` service under the `services` section in `.docksal/docksal.yml`

```yaml
  # Memcached
  memcached:
    hostname: memcached
    image: memcached
    environment:
      # Memcached memory limit in megabytes
      - MEMCACHED_MEMORY_LIMIT=128
```

Apply new configuration with `fin up`.

Use `memcached:11211` as the memcached endpoint.
