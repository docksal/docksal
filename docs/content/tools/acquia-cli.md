---
title: "Acquia CLI Commands"
aliases:
  - /en/master/tools/acquia-drush/
  - /tools/acquia-drush/
---


## Using Acquia Cloud CLI Commands

The [Acquia CLI](https://github.com/typhonius/acquia_cli) tool allows you 
to use all features of the Acquia Cloud API v2 on the command line.  

The tool is pre-installed in `cli` container. Note: required `docksal/cli` version: 2.11.0+.


## Configuration

Follow the [official docs](https://cloud.acquia.com/#/profile/tokens) to 
generate your Acquia Cloud API Token.  

Add your secret and key with

```bash
fin config set --global SECRET_ACQUIACLI_SECRET="lkjd*sdfl2//23498fwernoiuDHljw3897fsk"
fin config set --global SECRET_ACQUIACLI_KEY="rSxVZN35bo4jTuncGS+CiKdmhxLPL0BaPuyOv"
``` 

Refresh `cli` service configuration with `fin project start`. This will inject the values into `cli`
which will be used for authentication for the Acquia CLI.

Note: It is also possible to add/override these values via `.docksal/docksal-local.env` at the project level. 
Keep in mind, `.docksal/docksal-local.env` can be used for local overrides and should be excluded from git.
As such, it is best to use `.docksal/docksal-local.env` for any personal keys and tokens configured at the project level.


## Usage

Use `fin acquiacli <command>` from the host or `acquiacli <command>` inside `cli`.

Please refer to the [Acquia CLI readme](https://github.com/typhonius/acquia_cli) for usage details and
the [Acquia documentation](https://docs.acquia.com/acquia-cloud/develop/api/) for the options available
in the Acquia Cloud API v2.


## Integration

For easier integration with Acquia environment use the [pull command](/fin/fin-pull). 
This allows you to easily bring your assets (db, files, and code) down to your 
local environment quickly without manually running through the steps.
