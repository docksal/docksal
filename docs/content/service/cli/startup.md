---
title: "cli: Custom Startup"
---


{{% notice note %}}
Currently, custom startup scripts are only supported within the `cli` container.
{{% /notice %}}

## Configuring Startup Scripts

Startup scripts can be used to execute whenever a container is started. Usually this is the need to make sure a service 
is installed, to making sure a file is compiled, to possibly regenerating a key. This file is located within the projects 
`.docksal/services/cli` directory. The file name should be `startup.sh` and within there all commands will run at the time 
of container startup.

