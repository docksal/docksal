---
title: "Acquia Drush commands"
---


## Using Acquia Cloud Drush commands

Acquia Cloud Drush commands allow you to use all features of the Acquia Cloud API on the command line.  

Commands are pre-installed in `cli` container. Note: required `docksal/cli` version: 2.1.0+.


## Configuration

Follow the [official docs](https://docs.acquia.com/acquia-cloud/api/auth) to generate your Acquia Cloud API key.  

Add your email and key to `$HOME/.docksal/docksal.env`:

```
...
SECRET_ACAPI_EMAIL="user@example.com"
SECRET_ACAPI_KEY="rSxVZN35bo4jTuncGS+CiKdmhxLPL0BaPuyOvf510sKb6c4ycxZsfFpC/vjJgaMvGvpKi06iHoqX"
...
```

Refresh `cli` service configuration with `fin project start`. This will inject the values into `cli` and generate 
the credentials file (`/home/docker/.acquia/cloudapi.conf`) inside cli.

Use `fin drush <ac-command>` from the host or `drush <ac-command>` inside `cli`.

Please refer to the official [Acquia Cloud API](https://docs.acquia.com/acquia-cloud/api/drush-reference) for usage details.

Note: It is also possible to add/override these values via `.docksal/docksal.env` and `.docksal/docksal-local.env` at the project level. Keep in mind, `.docksal/docksal.env` is a shared configuration file and should be committed to git. `.docksal/docksal-local.env`, on the other hand, can be used for local overrides and should be excluded from git. As such, it is best to use `.docksal/docksal-local.env` for any personal keys and tokens configured at the project level.
