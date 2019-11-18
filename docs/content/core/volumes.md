---
title: "Shared Volumes"
weight: 3
aliases:
  - /en/master/advanced/volumes/
---

## Quick Overview

| OS      | VM              | DOCKSAL_VOLUMES              | Comments  |
|---------|-----------------|------------------------------|-----------|
| Linux   | -               | [bind](#bind) (**default**)  | Direct host files access, maximum filesystem speed. |
| macOS   | VirtualBox      | [nfs](#nfs)  (**default**)   | **Pros:** fast, ~20% slower than native filesystem. <br> **Cons:** does not support filesystem events (fsnotify). |
| macOS   | Docker Desktop  | [nfs](#nfs)  (**default**)   | **Pros:** fast, ~20% slower than native filesystem. <br> **Cons:** does not support filesystem events (fsnotify). |
| macOS   | Docker Desktop  | [bind](#bind)                | **Pros:** supports filesystem events. <br> **Cons:** pretty slow, 40% slower than native filesystem. |
| Windows | ANY             | [bind](#bind) (**default**)  | **Pros:** ~50% slower than native filesystem. <br> **Cons:** does not support filesystem events (fsnotify). |
| macOS, Windows | ANY      | [unison](#unison)            | **Pros:** maximum `cli` filesystem performance. <br> **Cons:** initial wait for files to sync into `cli`; additional Docksal disk space use; sync delay when you switch git branches; higher CPU usage during files sync; sometimes Unison may 'break.' |
| ANY     | ANY             | [none](#none)                | **Pros:** maximum `cli` filesystem performance and no wait for the initial sync. <br> **Cons:** you have to copy files manually or checkout and edit files inside `cli` container. |

## Project Volumes

If you are familiar with Docker Compose, then you must have attached files or dirs like this:

```yaml
  cli:
    volumes:
      - /Users/alex/mysite:/var/www:rw
```

That is a called a bind mount - mounting a files/folder on the host directly into a container. 
However, to support various OS in Docksal, we cannot always rely on bind mounts. 

Docksal defines several named Docker volumes per project for you:
 
- `project_root` stores your project files (see warnings below about use cases for this volume)
- `cli_home` stores home folder of your `cli` container independently of the `cli` container
- `db_data` stores your database data independently of the `db` container 
- `docksal_ssh_agent` stores SSH keys shared with all project stacks

Docksal makes these volumes to function transparently across different operating systems, but their actual definitions 
vary depending on the `DOCKSAL_VOLUMES` option.

{{% notice note %}}
`project_root` volume is mapped to a specific location on the host. 
If you need to move the location of a project on the computer, remove the project stack first with
`fin project rm`, then you can move the project folder and start the project stack again.
{{% /notice %}}

{{% notice warning %}}
When customizing `docksal.yml`, make sure to include the `cached` option **anywhere** the `project_root` volume is attached
to a service. Mixing `cached` and non-`cached` mounts for the same volume in your project stack will lead to issues 
and errors with Docker Desktop on macOS. See [docksal/docksal#678](https://github.com/docksal/docksal/issues/678) for more details.
{{% /notice %}}

## DOCKSAL_VOLUMES

`DOCKSAL_VOLUMES` value changes the mount type of the project volumes mentioned above and also affects `fin` behavior. 

### bind 

With this option, containers access files via a [bind mount](https://docs.docker.com/storage/bind-mounts/), which basically means direct access. 

While Docker can access files directly on Linux, on macOS and Windows it works inside the VM (VirtualBox, xhyve/Hyper-V 
with Docker Desktop), which means that Docker cannot directly access files from host. Those files have to be made 
available inside the VM first, and this is achieved in different ways on different operating systems and VMs.

**On macOS with VirtualBox**, files are made available from host to Docker by mounting the folder defined 
in `DOCKSAL_NFS_PATH` into the VM via NFS protocol.
 
```
             NFS mount                     bind mount
macOS Host ==============> VirtualBox VM =============> Container       
```

**On macOS with Docker Desktop**, it is Docker Desktop itself that mounts folders defined in Docker Desktop UI via 
[osxfs](https://docs.docker.com/docker-for-mac/osxfs/) file system.

```
             osxfs mount                    bind mount
macOS Host ==============> Docker Desktop ==============> Container   
``` 

**On Windows with VirtualBox**, Docksal mounts **all** physical drives into the VM via SMB protocol.

```
               SMB mount                    bind mount
Windows Host =============> VirtualBox VM ==============> Container   
```

**On Windows with Docker Desktop**, it is Docker Desktop itself that mounts **only** configured Windows drives via SMB.

```
               SMB mount                     bind mount
Windows Host =============> Docker Desktop ==============> Container   
```

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=bind`, see 
[stacks/volumes-bind.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-bind.yml).

In most cases, you do not need to set the `DOCKSAL_VOLUES=bind` option. It is set for you automatically. The only 
exception is when you need `fsnotify` events on macOS with Docker Desktop, but don't want to use the `unison` option.

### nfs

This option is macOS specific and is used by default with both VirtualBox and Docker Desktop.  
Docker mounts the `project_root` volume from the host over NFS, then project containers mount this volume. 

```
            volume mounted via NFS
macOS Host ========================> Container  
```

NFS generally works faster than `osxfs`. The downside is that NFS does not support `fsnotify` events.

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=nfs`, see 
[stacks/volumes-nfs.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-nfs.yml). 

### unison

This option only makes sense with Docker Desktop on macOS.

A `unison` container is added to the project stack with two volumes attached to it:

- a bind mount of the osxfs mount from the host - slow, but supports `fsnotify`
- a `project_root` named volume - native filesystem performance for containers (empty initially)

```
             osxfs mount                    bind mount                       named volume
macOS Host ==============> Docker Desktop ==============> unison container <============== project_root volume
```

The Unison daemon is responsible for syncing files between the two volumes.

```
unison container   -------> osxfs mount from macOS host (w/ fsnotify)
  two-way sync     \
  between volumes   \
                      ---> project_root volume 
```

The benefits of this setup:

- Native container file system performance for codebase reads and writes
- Support for filesystem watchers

The downsides:

- Initial sync can take time, especially on large codebases
- Higher disk space usage (double the size of the codebase)
- Additional CPU load from the Unison daemon 

#### Using "unison" Volumes

```bash
fin config set DOCKSAL_VOLUMES=unison
fin project reset
````

Wait until the initial unison sync finishes.

{{% notice note %}}
Once you set a new `DOCKSAL_VOLUMES` option, you must recreate the `cli` container. The easiest way is `fin project reset`,
but it will also remove all data from the `db` volume. If you want to retain it, remove only the `cli` container, and 
start the project again: `fin project remove cli; fin project start`
{{% /notice %}}

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=unison` see 
[stacks/volumes-unison.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-unison.yml).

### none

Advanced option. With this option, host files are made accessible to the VM like in a bind mount, but after that 
containers do not access them directly via bind, nor files are copied over. 
You would have to copy files into container and back manually.

Combined with [VSCode IDE](/tools/ide/), this option can provide a way of provisioning instant blank 
development environments with the best performance and consistency for Mac and Windows. 
The only added cost is having to stick with a browser-based IDE and terminal for developer UX. 

See [stacks/volumes-none.yml](https://github.com/docksal/docksal/blob/master/stacks/overrides-none.yml) for
details on Docker volumes definition with this option.

#### Using "none" Volumes

```bash
fin config set DOCKSAL_VOLUMES=none
fin project reset
```

Use `fin bash` to log into bash and checkout files into `/var/www` with git. Or use `fin docker cp` to copy 
files into the `cli` container. 
