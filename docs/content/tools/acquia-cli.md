---
title: "Acquia CLI Commands"
aliases:
  - /en/master/tools/acquia-drush/
  - /tools/acquia-drush/
---


## Using Acquia Cloud CLI Commands

The [Acquia CLI](https://github.com/acquia/cli) tool allows you 
to use all features of the Acquia Cloud API v2 on the command line.  

The tool is pre-installed in `cli` container. Note: required `docksal/cli` version: 2.13.0+.


## Configuration

Follow the [official docs](https://cloud.acquia.com/a/profile/tokens) to 
generate your Acquia Cloud API Token.  

Add your secret and key with

```bash
fin config set --global SECRET_ACQUIA_CLI_SECRET="i0bvTR9Dhf25Y6FzIK0j8NX//ll+GeAC7t75Jg4y8CE="
fin config set --global SECRET_ACQUIA_CLI_KEY="8842fd3a-e3f3-47e9-916f-6ff760e26358"
``` 

Refresh `cli` service configuration with `fin project start`. This will inject the values into `cli`
which will be used for authentication for the Acquia CLI.

{{% notice note %}}
It is also possible to add/override these values via `.docksal/docksal-local.env` at the project level (replace `--global` with `--env=local`). 
Keep in mind, `.docksal/docksal-local.env` can be used for local overrides and should be excluded from git.
As such, it is best to use `.docksal/docksal-local.env` for any personal keys and tokens configured at the project level.
{{% /notice %}}

## Usage

Use `fin acli <command>` from the host or `acli <command>` inside `cli`.

Please refer to the [Acquia CLI readme](https://github.com/acquia/cli) for usage details and
the [Acquia documentation](https://docs.acquia.com/acquia-cloud/develop/api/) for the options available
in the Acquia Cloud API v2.


## Integration

For easier integration with Acquia environment use the [pull command](/fin/fin-pull). 
This allows you to easily bring your assets (db, files, and code) down to your 
local environment quickly without manually running through the steps.
