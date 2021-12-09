---
title: "File Sharing"
weight: 3
aliases:
  - /en/master/advanced/file-sharing/
---


There are several ways the filesystem of the host machine can be made available to containers.  
By default, Docker does a bind-mount to a path on the host machine.

See [Use bind mounts](https://docs.docker.com/storage/volumes/) in the official Docker docs for a better understanding 
of how this works.

Docksal uses the bind-mount approach as well. From the perspective of a container a local Linux path  is mounted 
regardless of the host OS. That's because on macOS and Windows, there's always a Linux VM, and inside of the VM, 
the host's (macOS/Win) filesystem is mounted.

On macOS, the host's filesystem is mounted using NFS (VirtualBox mode only). On Windows, SMB is used (VirtualBox mode only).

{{% notice warning %}}
In Docker for Mac / Docker for Windows shared volumes configuration is not handled by Docksal.
You may have to manually configure the File Sharing options via Docker UI. See details [here](/getting-started/docker-modes/).    
{{% /notice %}}

## macOS

On macOS, `/Users` is configured as an NFS export by default with both VirtualBox and Docker Desktop. The `project_root`
volume is mounted from the host over NFS, then the project containers mount this volume. This export can only 
be accessed by the container and the host itself.

When you have other software, like Vagrant, defining NFS exports, there may be conflicts as NFS exports cannot overlap. 
In such cases the default NFS export can be overridden via the **global** `DOCKSAL_NFS_PATH` variable in 
`$HOME/.docksal/docksal.env`. You can set it using the following command:

```bash
fin config set --global DOCKSAL_NFS_PATH=/path/to/projects
```

It is also necessary to override this variable if your Docksal projects' directory resides in a location other than 
`/Users`, e.g., on a separate hard drive.

When the VM is started fin will detect NFS export conflicts and suggest an automatic fix.

We recommend using `DOCKSAL_NFS_PATH=~/Projects`. 

## Windows (VirtualBox mode only)

On Windows, Docksal sets up shares for all logical drives. These shares can be only accessed by the current Windows user.
