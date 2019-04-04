---
title: "Shared Cache Volumes"
weight: 1
---

**Currently Untested and Highly experimental**

Documenting the proof-of-concept of creating a shared composer cache directory and npm cache directory.

Docksal does not have a mechanism to manage user created volumes. In the event that the volume needs to be dropped, you 
will need to stop all existing projects, drop/recreate the volume, and then do reset cli in all projects that were mounting 
this external volume.

### Create a Named Volume

Run the following fin commands to create the volumes:

```
fin docker volume create composer-cache
fin docker volume create npm-cache
```

### Set docksal.yml


```
services:
  cli:
    environment:
      - COMPOSER_CACHE_DIR=/cache
    volumes:
      - composer_cache:/home/docker/.composer/cache
      - npm_cache:/home/docker/.npm

volumes:
  composer_cache:
    external: true
  npm_cache:
    external: true
```

(This is similar to how the global docksal_ssh_agent volume is mounted in cli.)
