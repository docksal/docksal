---
title: "Coder (Visual Studio Code web IDE)"
aliases:
  - /en/master/tools/cloud9/
---

[Coder](https://coder.com/) is a free, open-source web IDE.

## Enabling Coder


### Set the `IDE_ENABLED` Variable for the Project

Enable IDE for the project by setting the `IDE_ENABLED` variable:

```bash
fin config set --env=local IDE_ENABLED=1
```

{{% notice tip %}}
To enable for other developers within the project, remove the `--env=local` option from the above command.
{{% /notice %}}

Then, reset the cli service:

```bash
fin project reset cli
```

## Accessing IDE

After enabling, the IDE can be accessed at `ide-PROJECT_NAME.docksal`.


## Password Protect the IDE

Set the environment variable `IDE_PASSWORD` to your preferred password in the `.docksal/docksal.env` file to password
protect the IDE. When no value is set, a password is not required to access the IDE.


Requires cli:2.8 or greater.