# Enable Memcached support

## Append to `docksal.yml`

```
  # Memcached
  memcached:
    hostname: memcached
    image: memcached
    environment:
      # Memcached memory limit in megabytes
      - MEMCACHED_MEMORY_LIMIT=128
```

## Restart project containers

```
fin up
```

### Configuration

Use `memcached:11211` as the memcached endpoint.
