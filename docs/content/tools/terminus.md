---
title: "Terminus"
---


Terminus is [Pantheon's](https://pantheon.io) command line tool. It enables you to do almost everything in a terminal that you can do in the Dashboard, and much more.

Terminus is pre-installed in the `cli` container. Note: required `docksal/cli` version: 2.1.0+.


## Configuration

Follow the [official docs](https://pantheon.io/docs/terminus/install) to generate your machine token.  

Add the token to `$HOME/docksal/docksal.env`:

```
...
SECRET_TERMINUS_TOKEN="XMAG92S9_9gf5Mlhb7-JIEjVwYYhY-MGuKcspAdL0CjkU"
...
```

Refresh `cli` service configuration with `fin project start`. This will inject the token into `cli` and authenticate 
the container with Pantheon.

Use `fin terminus <command>` from the host or `terminus <command>` inside `cli`.

Please refer to the [official docs](https://pantheon.io/docs/terminus) for usage details.

Note: It is also possible to add/override these values via `.docksal/docksal.env` and `.docksal/docksal-local.env` at the project level. Keep in mind, `.docksal/docksal.env` is a shared configuration file and should be committed to git. `.docksal/docksal-local.env`, on the other hand, can be used for local overrides and should be excluded from git. As such, it is best to use `.docksal/docksal-local.env` for any personal keys and tokens configured at the project level.
