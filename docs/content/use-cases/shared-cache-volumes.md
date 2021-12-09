---
title: "Shared Cache Volumes"
weight: 1
---

**Currently Untested and Highly experimental**

Documenting the proof-of-concept of creating a shared composer cache (PHP) directory and npm cache directory (NodeJS).

This can be used to share the local caches of downloaded packages between multiple project stacks.

Docksal does not have a mechanism to manage user created volumes. In the event that the volume needs to be dropped, you 
will need to stop all existing projects, drop/recreate the volume, and then do `fin project reset cli` in all projects 
that were mounting this external volume.

Run the following fin commands to create the volumes for caches:

```bash
fin docker volume create composer_cache
fin docker volume create npm_cache
```

Update `docksal.yml` respectively:

```yaml
services:
  cli:
    volumes:
      - composer_cache:/home/docker/.composer/cache
      - npm_cache:/home/docker/.npm

volumes:
  composer_cache:
    external: true
  npm_cache:
    external: true
```

(This is similar to how the global `docksal_ssh_agent` volume is mounted in `cli`.)

Update the project stack:

```bash
fin project start
```
