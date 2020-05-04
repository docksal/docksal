---
title: "cli: NodeJS"
---

`docksal/cli` service images ship with an LTS version of NodeJS installed in a persistent volume in `/home/docker`.

When updating the `cli` service image, either from an explicit image tag or through a Docksal upgrade, and the new image 
uses a different NodeJS version, it's necessary to run `fin project reset cli` to update the version in the `docker` 
user's profile inside the image.


## Installing Alternate NodeJS Versions

If you require a different version of NodeJS, you have options.

### Install via nvm (at runtime)

Install the needed version via `nvm` at runtime:

```
fin exec nvm install 10.12.0
# Set the node default version
fin exec nvm alias default 10.12.0
```

Alternatively, you can use `.nvmrc` to set the required NodeJS version for the project:

```
fin exec echo 10.12.0 > .nvmrc
fin exec nvm install
```

To automate this with your project, you can put the command into the project's init script and have it happen 
every time you initialize the project with `fin init`.

Note, that as with any dependency installed at run-time, the image will not be immutable and is also internet connection 
dependent. Every time you reset/re-initialize the project stack and run `fin init`, that extra node version will be 
pulled down from the internet.

### Extend the stock Docksal image

You can [extend the stock Docksal image](/stack/extend-images/) to add the desired version of NodeJS.

There is a [full working example](https://github.com/docksal/example-nodejs) that demonstrates this very concept.


## Running a NodeJS Service

You can use the `cli` container to run a NodeJS service.

Use the [Override Command](/service/cli/override-command/) option to run a custom command at container start.

Bind your app to port `3000`, which is exposed automatically in `cli`.

If you need to run both PHP and NodeJS applications/services in your project, then run multiple instances of the `cli` 
container with different service names. Starting from the default stack (`DOCKSAL_STACK=default` set in your projects 
`docksal.env` file), add a `nodeapp` (the name can be different) service which extends from the `cli` service:

```yaml
services:
  nodeapp:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: cli
    labels:
      - io.docksal.virtual-host=nodeapp.${VIRTUAL_HOST}
      - io.docksal.virtual-port=3000
    command: ["bash", "-lc", "node nodeapp/index.js"]
```

The `node nodeapp/index.js` command above is an example and depends on how you run the NodeJS app in your project.  
The important part above is the `bash -lc` preamble, which is required to initialize the NodeJS environment in `cli`. 

`io.docksal.virtual-host` label tells the [vhost-proxy](/core/system-vhost-proxy/) system service which domain to route to this service.  
`io.docksal.virtual-port` tells it which port on the destination container to route the domains to.
 
Apply new configuration with `fin project start` (`fin p start`).

Use `http://nodeapp.<VIRTUAL_HOST>/` to access the NodeJS app.
