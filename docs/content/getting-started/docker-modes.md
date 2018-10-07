---
title: "Switching Docker modes"
weight: 2
---

## Using native Docker applications

After installation you can switch to using native Docker applications instead of VirtualBox, or vice versa.

## macOS

### Switching from VirtualBox to Docker for Mac

**Reconfigure Docksal**

Assuming that you have been previously using Docksal with VirtualBox, which was installed according to [setup docs](setup.md):

1. Install [Docker for Mac](https://docs.docker.com/docker-for-mac)

2. Open Terminal and run:

        fin vm stop
        fin config set --global DOCKER_NATIVE=1
        fin system reset

This stops Docksal VM, enables "native" mode, and resets Docksal system services.

**File sharing with Docker for Mac**

Docker for Mac automatically shares most commonly used volumes/directories.
See [Docker documentation](https://docs.docker.com/docker-for-mac/#file-sharing) for details.
It is usually not necessary to adjust these settings, but you want to check them if your Home folder
is not in a usual place.

Docksal automatically enables the `osxfs:cached` mode on Docker for Mac, which improves the file system read performance 
substantially. On Mac, `osxfs:cached` mode for Docker for Mac provides a decent read performance (still not as fast as NFS, but 
getting there). See [docksal/docksal#249](https://github.com/docksal/docksal/issues/249)


### Switching from Docker for Mac to VirtualBox 

1. Stop Docksal system

        fin system stop

1. Close Docker for Mac

1. Start with VM: 

        fin config set --global DOCKER_NATIVE=0
        fin vm start

This disables the "native" apps mode, resets network settings, starts Docksal VM, and resets Docksal system services.

## Windows

### Switching from VirtualBox to Docker for Windows

**Reconfigure Docksal**

Assuming that you have been previously using Docksal with Babun and VirtualBox, installed according to [setup docs](setup.md).

1. Install [Docker for Windows](https://docs.docker.com/docker-for-windows).

1. Open Babun and run:

        fin vm stop
        fin config set --global DOCKER_NATIVE=1
        fin system reset

This stops Docksal VM, enables "native" mode and resets Docksal system services.

**File sharing on Windows for Docker for Windows**

Share your local drives with Docker for Windows:

![Sharing Windows drives with Docker](/images/docker-for-win-share-drives.png)

### Switching from Docker for Windows to VirtualBox 

1. Stop Docksal system

        fin system stop

1. Close Docker for Windows

    On Windows, you will also have to **completely uninstall Hyper-V** (a dependency for Docker for Windows).  
    You won't be able to use VirtualBox (or any other hypervisor) while Hyper-V is installed. 
    Hyper-V locks the VT-x extension to itself, so other hypervisors are not able to use the hardware virtualization 
    support and cannot run 64bit VMs because of that.

1. Open Babun and run: 

        fin config set --global DOCKER_NATIVE=0
        fin vm start

This disables the "native" apps mode, resets network settings, starts Docksal VM, and resets Docksal system services.
