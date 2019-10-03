---
title: "cli: Custom Startup"
---


{{% notice note %}}
Currently, custom startup scripts are only supported within the `cli` container.
{{% /notice %}}

## Configuring Startup Script

A startup script can be used to execute actions whenever a container is started. This can be ensuring a service
is installed, making sure a file is compiled, or regenerating a key. This file is located within the projects
`.docksal/services/cli` directory and should be named `startup.sh`. All commands in the file will run at the time
of container startup. Make sure this file has execute permissions or it will not run.
