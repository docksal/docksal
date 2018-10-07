---
title: "Platform.sh"
---


Platform.sh offers a tool that allows for you to manage your projects from the command line. It enables you to do almost everything in a terminal that you can do in the Dashboard, and much more.

Platform.sh's CLI is pre-installed in the `cli` container. Note: required `docksal/cli` version: 2.3.0+.


## Configuration

Follow the [official docs](https://docs.platform.sh/gettingstarted/cli/api-tokens.html) to generate your API token.

Add the token to `$HOME/docksal/docksal.env`:

```
fin config set --global SECRET_PLATFORMSH_CLI_TOKEN="XMAG92S9_9gf5Mlhb7-JIEjVwYYhY-MGuKcspAdL0CjkU"
```

If you'd rather not put the token in your global environment file then the token can be added to `$PROJECT/docksal/docksal-local.env` by running:

```
fin config set --env=local SECRET_PLATFORMSH_CLI_TOKEN="XMAG92S9_9gf5Mlhb7-JIEjVwYYhY-MGuKcspAdL0CjkU"
```

Refresh `cli` service configuration with `fin project start`. This will inject the token into `cli` and authenticate
in the container with Platform.sh.

Use `fin platform <command>` from the host or `platform <command>` inside `cli`.

Please refer to the [official docs](https://docs.platform.sh/gettingstarted/cli.html#usage) for usage details.

Note: It is also possible to add/override these values via `.docksal/docksal.env` and `.docksal/docksal-local.env` at the project level. Keep in mind, `.docksal/docksal.env` is a shared configuration file and should be committed to git. `.docksal/docksal-local.env`, on the other hand, can be used for local overrides and should be excluded from git. As such, it is best to use `.docksal/docksal-local.env` for any personal keys and tokens configured at the project level.
