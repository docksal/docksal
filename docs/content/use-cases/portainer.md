---
title: "Portainer as a Web UI Option"
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

The UI can be accessed at [http://poratiner.docksal](http://poratiner.docksal/).

When accessing for the first time, set the username and password, then select Local as the Docker environment, click Connect.

![Portainer environments](/images/portainer-environments.png)

Portainer understands docker-composer projects/stacks, so it's able to list Docksal projects and their containers. 
It is not able to control them in the same way it can control its own stacks.

Here's are the use cases that work:

* listing projects
* listing project containers
* web console into a specific container
* view/filter container logs

Here's are the use cases that don't fully work or don't work at all:

* adding/stopping/starting/removing - projects
* stopping/starting containers within a project - Portainer will start/stop project containers, however Docksal handles more than just that behind the scenes.


## Uninstall

```bash
$ docker rm -vf portainer
$ docker volume rm -f portainer_data
```




