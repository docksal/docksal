---
title: "Pantheon (Terminus)"
aliases:
  - /en/master/tools/terminus/
---


Terminus is [Pantheon's](https://pantheon.io) command line tool. It enables you to do almost everything in a terminal that you can do in the Dashboard, and much more.

Terminus is pre-installed in the `cli` container. Note: required `docksal/cli` version: 2.1.0+.


## Configuration

Follow the [official docs](https://pantheon.io/docs/terminus/install) to generate your machine token and then add the token to your global configuration:  

```
fin config set --global SECRET_TERMINUS_TOKEN="XMAG92S9_9gf5Mlhb7-JIEjVwYYhY-MGuKcspAdL0CjkU"
```

Refresh `cli` service configuration with `fin project start`. This will inject the token into `cli` and authenticate 
the container with Pantheon.

Use `fin terminus <command>` from the host or `terminus <command>` inside `cli`.

Please refer to the [official docs](https://pantheon.io/docs/terminus) for usage details.

{{% notice note %}}
It is also possible to add/override these values via `.docksal/docksal-local.env` at the project level (replace `--global` with `--env=local`).
Keep in mind, `.docksal/docksal-local.env` can be used for local overrides and should be excluded from git.
As such, it is best to use `.docksal/docksal-local.env` for any personal keys and tokens configured at the project level.
{{% /notice %}}

## Integration

For easier integration with Pantheon environment use the [pull command](/fin/fin-pull). 
This allows you to easily bring your assets (db, files, and code) down to your 
local environment quickly without manually running through the steps.
