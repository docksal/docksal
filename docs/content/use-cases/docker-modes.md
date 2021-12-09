---
title: "Switching Docker Modes"
aliases:
  - /en/master/getting-started/docker-modes/
  - /getting-started/docker-modes/
---


Docksal supports two operation modes on Mac and Windows:

- VirtualBox VM (default)
- Docker Desktop for Mac/Windows

You can switch between these modes at any time using the instructions below.

{{% notice note %}}
While preserved in the original instance, Docker data (images, containers, volumes) is not automatically transferred over
between VirtualBox and Docker Desktop instances. They are completely separate VMs.
{{% /notice %}} 

{{% notice note %}}
Running in both modes at the same time is not supported.
{{% /notice %}} 


## macOS


### Switching from VirtualBox to Docker Desktop for Mac

**Reconfigure Docksal**

Assuming that you have been previously using Docksal with VirtualBox, which was installed according to [setup docs](/getting-started/setup/):

1. Stop Docksal VirtualBox VM (run in Terminal):

        fin system stop

2. Install/launch [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/)

3. Start Docksal in Docker Desktop mode (run in Terminal):

        fin config set --global DOCKER_NATIVE=1
        fin system start

**File sharing with Docker for Mac**

Docker for Mac automatically shares most commonly used volumes/directories. As of Docksal 1.13.0, this 
is done through NFS. See [Docker documentation](https://docs.docker.com/docker-for-mac/#file-sharing) for details.
It is usually not necessary to adjust these settings, but you want to set the DOCKSAL_NFS_PATH value in the 
`~/.docksal/docksal.env` file if your Home folder is not in a usual place. See
 [File Sharing](/core/file-sharing/#macos-virtualbox-mode-only).

Docksal automatically enables the `osxfs:cached` mode on Docker for Mac, which improves the file system read performance 
substantially. On Mac, `osxfs:cached` mode for Docker for Mac provides a decent read performance (still not as fast as NFS, but 
getting there). See [docksal/docksal#249](https://github.com/docksal/docksal/issues/249)


### Switching from Docker Desktop for Mac to VirtualBox 

1. Stop Docksal in Docker Desktop (run in Terminal):

        fin system stop

2. Quit Docker Desktop app

3. Start Docksal in VirtualBox VM mode (run in Terminal):

        fin config set --global DOCKER_NATIVE=0
        fin system start


## Windows


### Switching from VirtualBox to Docker Desktop for Windows

**Reconfigure Docksal**

1. Stop Docksal VirtualBox VM (run in WSL):

        fin system stop

2. Install/launch [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install/).

3. Start Docksal in Docker Desktop mode (run in WSL):

        fin config set --global DOCKER_NATIVE=1
        fin system start

**File sharing on Windows for Docker for Windows**

Share your local drives with Docker for Windows:

![Sharing Windows drives with Docker](/images/docker-for-win-share-drives.png)


### Switching from Docker Desktop for Windows to VirtualBox 

1. Stop Docksal in Docker Desktop (run in WSL):

        fin system stop

2. Quit Docker Desktop app

    You will also have to **completely uninstall Hyper-V** (a dependency for Docker Desktop for Windows).  
    You won't be able to use VirtualBox (or any other hypervisor) while Hyper-V is installed. 
    Hyper-V locks the VT-x extension to itself, so other hypervisors are not able to use the hardware virtualization 
    support and cannot run 64bit VMs because of that.

3. Start Docksal in VirtualBox VM mode (run in WSL):

        fin config set --global DOCKER_NATIVE=0
        fin system start
