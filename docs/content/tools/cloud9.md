---
title: "Cloud9 IDE"
---


Cloud9 is an open source, web based IDE (integrated development environment) that allows for a developer to make changes
to code without working from their desktop or needing additional tools.

![Cloud9 IDE](/images/cloud9-ide-screenshot.png)


## Enabling Cloud9


### Set the `IDE_ENABLED` variable for the project.

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

After enabling, the IDE can be accessed at `ide.PROJECT_NAME.docksal`.


{{% notice note %}}
Since vhost-proxy does not support routing more than a single custom port, IDE mode cannot be used in conjunction
with the nodejs stack (`stack-node.yml`).
{{% /notice %}}
