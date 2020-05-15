---
title: "Redis"
aliases:
  - /en/master/tools/redis/
  - /tools/redis/
---

Docksal does not maintain a Redis image as there are multiple other ways to accomplish integration at this time.

## Use wodby/redis with Config Variables

This is the default method.

Add the following to the `docksal.yml` file in your project.

```yaml
version: "2.1"

services:
  # Redis
  redis:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: redis
```

The following variables may be set within your project's `docksal.env` file.

{{% notice note %}}
This list may become outdated. Please check [wodby/redis](https://github.com/wodby/redis) for the up-to-date list.
{{% /notice %}}

| Variable                          | Default Value           |
| --------------------------------- | ----------------------- |
| `REDIS_ACTIVE_REHASHING`          | `yes`                   |
| `REDIS_APPENDONLY`                | `no`                    |
| `REDIS_DATABASES`                 | `16`                    |
| `REDIS_DBFILENAME`                | `dump.rdb`              |
| `REDIS_LATENCY_MONITOR_THRESHOLD` | `0`                     |
| `REDIS_LIST_MAX_ZIPLIST_ENTRIES`  | `512`                   |
| `REDIS_LIST_MAX_ZIPLIST_VALUE`    | `64`                    |
| `REDIS_LOGFILE`                   |                         |
| `REDIS_LUA_TIME_LIMIT`            | `5000`                  |
| `REDIS_MAXMEMORY`                 | `128m`                  |
| `REDIS_MAXMEMORY_POLICY`          | `allkeys-lru`           |
| `REDIS_MAXMEMORY_SAMPLES`         | `3`                     |
| `REDIS_NOTIFY_KEYSPACE_EVENTS`    |                         |
| `REDIS_PASSWORD`                  |                         |
| `REDIS_SAVE_TO_DISK`              |                         |
| `REDIS_SAVES`                     | `900:1/300:10/60:10000` |
| `REDIS_SET_MAX_INTSET_ENTRIES`    | `512`                   |
| `REDIS_SLOWLOG_MAX_LEN`           | `32`                    |
| `REDIS_SLOWLOG_SLOWER_THAN`       | `10000`                 |
| `REDIS_TCP_BACKLOG`               | `511`                   |
| `REDIS_TCP_KEEPALIVE`             | `60`                    |
| `REDIS_TIMEOUT`                   | `300`                   |


## Use the Official Redis Image with a Custom Config File

This can be done by adding a line to reference the custom config file (`.docksal/etc/redis/redis.conf`) in the `docksal.yml` file. The following is an example.

```yaml
version: "2.1"

services:
  redis:
    hostname: redis
    image: redis:4.0-alpine
    volumes:
      - ${PROJECT_ROOT}/.docksal/etc/redis/redis.conf:/usr/local/etc/redis/redis.conf
    command: [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
```


## Extending the Official Redis Image

Redis can also be configured by extending the stock image within a Dockerfile. For more
information, consult the [Extending stock Docksal Images](/stack/extend-images/) documentation.

## Accessing the Redis instance

If you need command line access to the Redis instance you can run `fin exec --in=redis redis-cli`.
