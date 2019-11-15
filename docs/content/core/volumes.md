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
| macOS   | VirtualBox      | [nfs](#nfs)  (**default**)   | **Pros:** fast, only 10-15% slower than native filesystem. <br> **Cons:** does not support filesystem events (fsnotify). |
| macOS   | Docker Desktop  | [nfs](#nfs)  (**default**)   | **Pros:** fast, only 10-15% slower than native filesystem. <br> **Cons:** does not support filesystem events (fsnotify). |
| macOS   | Docker Desktop  | [bind](#bind)                | **Pros:** supports filesystem events. <br> **Cons:** pretty slow, 40% slower than native filesystem. |
| Windows | ANY             | [bind](#bind) (**default**)  | **Pros:** ~20% overhead as compared to native FS. <br> **Cons:** does not support filesystem events (fsnotify). |
| macOS, Windows | ANY      | [unison](#unison)            | **Pros:** maximum `cli` filesystem performance. <br> **Cons:** initial wait for files to sync into `cli`; additional Docksal disk space use; sync delay when you switch git branches; higher CPU usage during files sync; sometimes Unison might 'break.' |
| ANY     | ANY             | [none](#none)                | **Pros:** maximum `cli` filesystem performance and no wait for the initial sync. <br> **Cons:** you have to copy files manually or checkout and edit files inside `cli` container. |

## Project Volumes

If you are familiar with Docker Compose, then you must have attached files or dirs like this:

```yaml
  cli:
    volumes:
      - /Users/alex/mysite:/var/www:rw
```

It is an unnamed volume with bind driver. However to support various OS in Docksal we cannot just always rely on the 
bind driver, and should not use unnamed volumes. 

Instead Docksal defines several named Docker volumes per project for you:
 
- `project_root` stores your project files (see warnings below abut usecases of this volume)
- `cli_home` to store home folder of your `cli` container independently of the `cli` container
- `db_data` to store your database data independently of the `db` container 
- `docksal_ssh_agent` to share SSH keys with containers

Docksal made these volumes to function transparently across different operating systems, but their actual definitions 
vary depending on the `DOCKSAL_VOLUMES` option.

{{% notice note %}}
`project_root` volume is mapped to a specific location on the host. 
If you need to move the location of a project on the computer, remove the project stack first with
`fin project rm`, then you can move the project folder and start the project stack again.
{{% /notice %}}

{{% notice warning %}}
When customizing `docksal.yml` make sure to include the `cached` option **anywhere** the `project_root` volume is attached
to a service. Mixing `cached` and non-`cached` mounts for the same volume in your project stack will lead to 
issues and errors with Docker Desktop on macOS. See [docksal/docksal#678](https://github.com/docksal/docksal/issues/678) for more details.
{{% /notice %}}

## DOCKSAL_VOLUMES

`DOCKSAL_VOLUMES` value changes the driver option for project volumes mentioned above, and also affects some additional `fin` behavior. 

### bind 

With this option containers access files using **Docker bind** driver option, which basically means direct access. 

While Docker can access files directly on Linux, on macOS and Windows it works inside VM (VirtualBox or xhyve with Docker Desktop), 
which means that Docker cannot directly access files from host. Those files have to be made available inside VM first, 
and this is achieved in a different ways on different operating systems and VMs.

**On macOS with VirtualBox** files are made available from host to Docker by mounting the folder defined 
in `DOCKSAL_NFS_PATH` into VM via NFS protocol.
 
```
             NFS mount                       bind
macOS Host ==============> VirtualBox VM =============> Container       
```

**On macOS with Docker Desktop** it is Docker Desktop itself that mounts folders defined in Docker Desktop UI via `osxfs` 
network filesystem.

```
               osxfs                         bind
macOS Host ==============> Docker Desktop ==============> Container   
``` 

**On Windows with VirtualBox** Docksal mounts all available Windows drives into VM via SMB protocol.

```
               SMB mount                      bind
Windows Host =============> VirtualBox VM ==============> Container   
```

**On Windows with Docker Desktop** it is Docker Desktop itself that mounts all configured Windows drives via SMB.

```
               SMB mount                       bind
Windows Host =============> Docker Desktop ==============> Container   
```

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=bind` see 
[stacks/volumes-bind.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-bind.yml).

In most cases you do not need to set `DOCKSAL_VOLUES=bind` option. It is set for you automatically 
in applicable cases. The only thinkable exception is when you need fsnotify events on macOS with Docker Desktop, 
but don't want to use `unison` option.

### nfs

This option is macOS specific and is used by default on macOS instead of bind. It means that containers will not wait 
for something to make host files accessible for them first, instead they will reach out to host themselves via NFS protocol.

```
              NFS mount
macOS Host ==============> Container  
```

NFS generally works faster than `osxfs` so this option is default on macOS even for Docker Desktop setup. The downside
is that NFS does not support fsnotify events.

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=nfs` see 
[stacks/volumes-nfs.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-nfs.yml). 

### unison

This option only works on macOS and Windows. Host files are made accessible to VM like in a bind mount, but after
that container does not access them directly via bind to avoid NFS/SMB performance penalty. Container file system is not 
connected to host filesystem at all.   

Instead `fin` launches a `unison` container with Unison daemon that copies files back and forth between mounted host 
files and the container. Transferrring changes from host to the container and back becomes slower, but reading and writing 
the files within the container becomes way faster.

```
       NFS/SMB/osxfs                          Copy via Unison daemon
Host =================> VM/Docker Desktop < - - - - - - - - - - - - - > Container
```

The benefits of this setup:

- Full native container file system performance (reads and writes)
- `ionitify` event support **when Docker Desktop is used**

The downsides:

- Initial sync can take time, especially on large codebases
- Higher disk space usage (double the size of the codebase)
- Additional CPU load from the Unison daemon 

#### Using Unison Volumes

- Add `DOCKSAL_VOLUMES=unison` into `.docksal/docksal.env` of a project
- `fin project reset`
- Wait until initial sync finishes.

{{% notice note %}}
Once you set a new `DOCKSAL_VOLUMES` option, you must re-create `cli` container. The easiest way is `fin project reset`,
but it will also remove all data from the `db` volume. If you want to retain it then remove only `cli` container, and 
start the project again: `fin project remove cli; fin project start`
{{% /notice %}}

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=unison` see 
[stacks/volumes-unison.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-unison.yml).

### none

Advanced option. With this option host files are made accessible to VM like in a bind mount, but after that 
container does not access them directly via bind, nor files are copied over. 
You would have to copy files into container and back manually.

Combined with [VSCode IDE](/tools/ide/) this option can provide a way of provisioning instant blank 
development environments with the best performance and consistency for Mac and Windows. 
The only added cost is having to stick with a browser-based IDE and terminal for file operations. 

See [stacks/volumes-none.yml](https://github.com/docksal/docksal/blob/master/stacks/overrides-none.yml) for
details on Docker volumes definition with this option.

#### Using None Volumes

- Add `DOCKSAL_VOLUMES=none` into `.docksal/docksal.env` of a project
- `fin project reset`

Use `fin bash` to log into bash and checkout files into `/var/www` with git. Or use `docker cp` to copy 
files into the `cli` container. 
