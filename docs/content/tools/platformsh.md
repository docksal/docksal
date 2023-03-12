---
title: "Platform.sh"
aliases:
  - /en/master/tools/platformsh/
---


Platform.sh offers a tool that allows you to manage your projects from the command line. It enables you to do almost everything in a terminal that you can do in the Dashboard, and much more.

Platform.sh's CLI is pre-installed in the `cli` container. Note: required `docksal/cli` version: 2.3.0+.


## Configuration

Follow the [official docs](https://docs.platform.sh/gettingstarted/cli/api-tokens.html) to generate your API token 
and then add the token to your global configuration:

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

{{% notice note %}}
It is also possible to add/override these values via `.docksal/docksal-local.env` at the project level (replace `--global` with `--env=local`).
Keep in mind, `.docksal/docksal-local.env` can be used for local overrides and should be excluded from git.
As such, it is best to use `.docksal/docksal-local.env` for any personal keys and tokens configured at the project level.
{{% /notice %}}

## Integration

For easier integration with Platform.sh environment use the [pull command](/fin/fin-pull).
This allows you to easily bring your assets (db, files, and code) down to your 
local environment quickly without manually running through the steps.
