---
title: "Using Redis"
---


Docksal does not have any self maintained images as there are other integrations that are available at this time.
There are multiple different ways to accomplish this.


## Custom Redis Config File

This can be done by adding a line to reference the custom config file (`.docksal/etc/redis/redis.conf`) in the `docksal.yml` file. The following is an example.

```yml
version: "2.1"

services:
  redis:
    hostname: redis
    image: redis:4.0-alpine
    volumes:
      - ${PROJECT_ROOT}/.docksal/etc/redis/redis.conf:/usr/local/etc/redis/redis.conf
    command: [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
```


## Configure Environmental Variables For Docker Image

This would require using the [wodby/redis](https://github.com/wodby/redis) image.

Add the following to the `docksal.yml` file.

```yml
version: "2.1"

services:
  redis:
    hostname: redis
    image: wodby/redis:4.0
    environment:
      - REDIS_MAXMEMORY=256m
```


### Environment Variables

The following is listed on the [wodby/redis](https://github.com/wodby/redis) image for reference.
**NOTE** This list may not be update to date with the repository.

| Variable                          | Default Value           | Description |
| --------------------------------- | ----------------------- | ----------- |
| `REDIS_ACTIVE_REHASHING`          | `yes`                   |             |
| `REDIS_APPENDONLY`                | `no`                    |             |
| `REDIS_DATABASES`                 | `16`                    |             |
| `REDIS_DBFILENAME`                | `dump.rdb`              |             |
| `REDIS_LATENCY_MONITOR_THRESHOLD` | `0`                     |             |
| `REDIS_LIST_MAX_ZIPLIST_ENTRIES`  | `512`                   |             |
| `REDIS_LIST_MAX_ZIPLIST_VALUE`    | `64`                    |             |
| `REDIS_LOGFILE`                   |                         |             |
| `REDIS_LUA_TIME_LIMIT`            | `5000`                  |             |
| `REDIS_MAXMEMORY`                 | `128m`                  |             |
| `REDIS_MAXMEMORY_POLICY`          | `allkeys-lru`           |             |
| `REDIS_MAXMEMORY_SAMPLES`         | `3`                     |             |
| `REDIS_NOTIFY_KEYSPACE_EVENTS`    |                         |             |
| `REDIS_PASSWORD`                  |                         |             |
| `REDIS_SAVE_TO_DISK`              |                         |             |
| `REDIS_SAVES`                     | `900:1/300:10/60:10000` |             |
| `REDIS_SET_MAX_INTSET_ENTRIES`    | `512`                   |             |
| `REDIS_SLOWLOG_MAX_LEN`           | `32`                    |             |
| `REDIS_SLOWLOG_SLOWER_THAN`       | `10000`                 |             |
| `REDIS_TCP_BACKLOG`               | `511`                   |             |
| `REDIS_TCP_KEEPALIVE`             | `60`                    |             |
| `REDIS_TIMEOUT`                   | `300`                   |             |


## Extending the Stock Image

Redis can also be configured by extending the stock image within a Dockerfile. For more
information, consult the [Extending stock Docksal Images](../advanced/extend-images.md) documentation.