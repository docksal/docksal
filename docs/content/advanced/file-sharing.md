---
title: "File sharing"
---


There are several ways the filesystem of the host machine can be made available to containers.  
By default, Docker does a bind-mount to a path on the host machine.

See [Mount a host directory as a data volume](https://docs.docker.com/engine/tutorials/dockervolumes/#mount-a-host-directory-as-a-data-volume) 
in the official Docker docs for a better understanding of how this works.

Docksal uses the bind-mount approach as well. From the perspective of a container a local Linux path  is mounted regardless of the host OS. That's because on macOS and Windows, there's always a Linux VM, and inside of the VM, the host's (macOS/Win) filesystem is mounted.

On macOS the host filesystem is mounted using NFS, on Windows - using SMB.

## macOS

On macOS `/Users` is configured as an NFS export by default and mounted into `/Users` in the VM. This export can only 
be accessed by the Docksal VM and the host itself.

When you have other software, like Vagrant, defining NFS exports, there may be conflicts as NFS exports cannot overlap. 
In such cases the default NFS export can be overridden via the `DOCKSAL_NFS_PATH` variable in `$HOME/.docksal/docksal.env`. It is also necessary to set this variable if your user directory resides in a location other than `/Users`, e.g., on a separate hard drive.

When the VM is started fin will detect NFS export conflicts and suggest an automatic fix.

We recommend using `DOCKSAL_NFS_PATH=~/Projects`. 

## Windows

On Windows, Docksal sets up shares for all logical drives. These shares can be only accessed by the current Windows user.
