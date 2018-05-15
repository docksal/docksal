# Using native Docker applications

On Mac and Windows, you can use native Docker applications instead of VirtualBox.

!!! info "Soon to be mainstream"
    Docker for Mac/Windows will soon become the recommended way of working with Docksal on Mac and Windows.
    VirtualBox will still be supported, however the focus will shift towards using the native Docker apps. 

On Mac, `osxfs:cached` mode for Docker for Mac provides a decent read performance (still not as fast as NFS, but 
getting there). See [docksal/docksal#249](https://github.com/docksal/docksal/issues/249)

On Windows, Windows 10 Fall Creators Update 1709 disables SMBv1, which is necessary for SMB sharing support with 
VirtualBox/boo2docker. See [docksal/docksal#382](https://github.com/docksal/docksal/issues/382) for more details.


## Using Docksal with Docker for Mac/Windows (new users)

Follow instructions in this section, if this is the first time you are installing Docksal.

**1.** Install Docker for [Mac](https://docs.docker.com/docker-for-mac) or [Windows](https://docs.docker.com/docker-for-windows).

**2.** Install Docksal (native mode enabled automatically).

```bash
curl -fsSL https://get.docksal.io | DOCKER_NATIVE=1 sh
```

Configure file sharing as necessary (see below).


## Switching to Docker for Mac/Windows (existing users)

Follow instructions in this section if you've been previously using Docksal with VirtualBox.

**1.** Install Docker for [Mac](https://docs.docker.com/docker-for-mac) or [Windows](https://docs.docker.com/docker-for-windows).

**2.** Stop Docksal VM, enable "native" apps mode and reset Docksal system services

```bash
fin vm stop
fin config set --global DOCKSAL_NATIVE=1
fin system reset
```

Configure file sharing as necessary (see below).


## File sharing with Docker for Mac/Windows

### File sharing Mac

Docker for Mac automatically shares most commonly used volumes/directories. 
See [Docker documentation](https://docs.docker.com/docker-for-mac/#file-sharing) for details.  
It is usually not necessary to adjust these settings.

Docksal automatically enables the `osxfs:cached` mode on Docker for Mac, which improves the file system read performance 
substantially.

### File sharing Windows

Docker for Windows does NOT share drives automatically. This has to be done manually. 
See [here](https://docs.docker.com/docker-for-windows/#shared-drives) for details.  
Configure sharing for the drive where your "Projects" folder is (`C:` in most cases).


## Switching to VirtualBox (existing users)

**1.** Close the "native" Docker app

On Windows, you will also have to **completely uninstall Hyper-V** (a dependency for Docker for Windows).  
You won't be able to use VirtualBox (or any other hypervisor) while Hyper-V is installed. 
Hyper-V locks the VT-x extension to itself, so other hypervisors are not able to use the hardware virtualization 
support and cannot run 64bit VMs because of that.

**2.** Disable the "native" apps mode, reset networks settings, start Docksal VM and reset Docksal system services

```bash
fin config set --global DOCKSAL_NATIVE=0
fin system reset network
fin vm start
fin system reset
```
