---
title: "Docker Web UI: Portainer"
weight: 1
---

[Portainer](https://github.com/portainer/portainer) is a really nice web UI for Docker.

>Portainer is a lightweight management UI which allows you to easily manage your different Docker environments 
(Docker hosts or Swarm clusters). Portainer is meant to be as simple to deploy as it is to use. It consists of 
a single container that can run on any Docker engine (can be deployed as Linux container or a Windows native container, 
supports other platforms too). Portainer allows you to manage all your Docker resources (containers, images, volumes, 
networks and more) ! It is compatible with the standalone Docker engine and with Docker Swarm mode.

With support for compose/stacks it can now properly display Docker Compose based projects:

![Portainer stacks list](/images/portainer-stacks-list.png)

Display project stack containers:

![Portainer stack details](/images/portainer-stack-details.png)

Can open a web terminal into any container:

![Portainer container console](/images/portainer-container-console.png)

Can display logs with filtering:

![Portainer container logs](/images/portainer-container-logs.png)

## Install

```bash
$ docker volume create portainer_data
$ docker run --name portainer -d -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data --label='io.docksal.virtual-host=portainer.*' --label=io.docksal.virtual-port=9000 portainer/portainer -H unix:///var/run/docker.sock
```

## Usage

The UI can be accessed at [http://portainer.docksal](http://portainer.docksal/).

When accessing for the first time, set the username and password.

Portainer understands Docker Composer projects/stacks, so it's able to list Docksal projects and their containers. 
However, Portainer is not able to control them in the same way it can control its own stacks, as there are various 
extra steps that Docksal handles behind the scenes in that process. 

Use cases that work well:

* list project stacks
* list project stack containers
* view container configuration
* **web console into a specific container**
* **view/filter container logs**

Use cases that may not work as expected:

* adding/stopping/starting/removing project stacks

While using Portainer to start/stop **all** containers in a stack is OK, it is not advised to remove project containers 
this way. Doing so will result in multiple leftovers on the Docker host and can eventually lead to issues.


## Uninstall

```bash
$ docker rm -vf portainer
$ docker volume rm -f portainer_data
```
