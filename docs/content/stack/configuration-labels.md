---
title: "Configuration Labels"
weight: 5
---
## Configuration Labels

Configuration labels are special Docker Compose labels that can be assigned to containers in your `docksal.yml` or `docksal-local.yml` files and impact how containers function in Docksal.

For example this will create a `yoda` service, based on `cli`, that has shell and user overridden so that `npm` and `node` commands would execute properly against it (e.g., `fin exec --in=yoda npm -v`). 

```yaml
services:
  yoda:
    labels:
      - io.docksal.shell=bash
      - io.docksal.user=docker
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: cli
```

### io.docksal.shell

Specify which shell to use when `fin exec --in=container ...` or `fin bash container` commands are executed for the container.

You must make sure that the shell you specify is installed in the container or the command will fail.

### io.docksal.user

Specify which user to use when `fin exec --in=container ...` or `fin bash container` commands are executed for the container.

### io.docksal.virtual-host

Assign custom virtual host for a container. This will only make sense if the container exposes a web interface, e.g., 

```yaml
    labels:
      - io.docksal.virtual-host=nodeapp.${VIRTUAL_HOST}
```

### io.docksal.virtual-port

Assign to which port on the destination container to route web requests, e.g., for node app that exposes port 3000

```yaml
    labels:
      - io.docksal.virtual-host=nodeapp.${VIRTUAL_HOST}
      - io.docksal.virtual-port=3000
```
