---
title: "Shared Volumes"
weight: 3
aliases:
  - /en/master/advanced/volumes/
---

## Quick Overview {#overview}

| OS      | VM              | DOCKSAL_VOLUMES options             | FS Speed | FS Events | Comments                                                                       |
|---------|-----------------|-------------------------------------|-------   |-----------|--------------------------------------------------------------------------------|
| Linux   | -               | [bind](#volumes-bind) (**default**) | 100%     | Yes       | Direct host files access, maximum filesystem speed.                            |
| macOS   | VirtualBox      | [nfs](#volumes-nfs) (**default**)   | 80%      |           | Uses NFS for a balanced experience on macOS, stable, lightweight.              |
| macOS   | Docker Desktop  | [nfs](#volumes-nfs) (**default**)   | 80%      |           | Uses NFS for a balanced experience on macOS, stable, lightweight.              |
| macOS   | Docker Desktop  | [bind](#volumes-bind)               | 60%      | Yes       | Uses Docker Desktop, slow, can cause higher CPU usage.                         |
| macOS   | Docker Desktop  | [unison](#volumes-unison)           | 100%     | Yes       | Uses Docker Desktop + Unison, can be unstable (especially on large codebases). |
| macOS   | Docker Desktop  | [mutagen](#volumes-mutagen)         | 100%     | Yes       | Uses Mutagen, needs monitoring and ramp up.                                    |
| Windows | ANY             | [bind](#volumes-bind) (**default**) | 50%      |           | Uses SMB, slow.                                                                |
| ANY     | ANY             | [none](#volumes-none)               | 100%     |           | Nothing is mounted or synced, maximum filesystem speed.                        |

## Project Volumes

If you are familiar with Docker Compose, then you must have attached files or dirs like this:

```yaml
  cli:
    volumes:
      - /Users/alex/mysite:/var/www:rw
```

That is a called a bind mount - mounting a file/directory directly into a container.
However, to support various OS in Docksal, we cannot always rely on bind mounts.

Docksal defines several named Docker volumes per project for you:

- `project_root` stores your project files (see warnings below about use cases for this volume)
- `cli_home` stores home directory of your `cli` container independently of the `cli` container
- `db_data` stores your database data independently of the `db` container
- `docksal_ssh_agent` stores SSH keys shared with all project stacks

Docksal makes these volumes to function transparently across different operating systems, but their actual definitions
vary depending on the `DOCKSAL_VOLUMES` option.

{{% notice note %}}
`project_root` volume is mapped to a specific location on the host.
If you need to move the location of a project on the computer, remove the project stack first with
`fin project rm`, then you can move the project directory and start the project stack again.
{{% /notice %}}

{{% notice warning %}}
When customizing `docksal.yml`, make sure to include the `cached` option **anywhere** the `project_root` volume is attached
to a service. Mixing `cached` and non-`cached` mounts for the same volume in your project stack will lead to issues
and errors with Docker Desktop on macOS. See [docksal/docksal#678](https://github.com/docksal/docksal/issues/678) for more details.
{{% /notice %}}

## DOCKSAL_VOLUMES

`DOCKSAL_VOLUMES` value changes the mount type of the project volumes mentioned above and also affects `fin` behavior.

The value can be set globally (all projects)

```bash
fin config set --global DOCKSAL_VOLUMES=<value>
fin system reset
```

or per project

```bash
fin config set DOCKSAL_VOLUMES=<value>
fin project reset
```

{{% notice warning %}}
Switching volumes is a destructive operation for the whole project stack. To preserve the database state, it has to
be exported before and then imported back after switching volume modes.
{{% /notice %}}

See the table in the [overview](#overview) section for appropriate values based on OS/VM environment.

To check the current value, run `fin config get DOCKSAL_VOLUMES` / `fin config get --global DOCKSAL_VOLUMES`

### DOCKSAL_VOLUMES=bind {#volumes-bind}

With this option, containers access files via a [bind mount](https://docs.docker.com/storage/bind-mounts/),
which basically means direct access to the underlying filesystem.

While Docker enjoys direct filesystem access on Linux, on macOS and Windows Docker works inside a VM (VirtualBox,
xhyve/Hyper-V with Docker Desktop) and thus cannot directly access files on the host machine. Those files have to be
made available inside the VM first, and that can be handled differently on different operating systems and VMs.

**On macOS with VirtualBox**, files are made available from host to Docker by mounting the directory defined
in `DOCKSAL_NFS_PATH` into the VM via NFS protocol.

```
             NFS mount    directory     bind mount
macOS Host <=========== VirtualBox VM <============ Container
```

**On macOS with Docker Desktop**, it is Docker Desktop itself that mounts directories defined in Docker Desktop UI using
[various filesystem options](https://docs.docker.com/desktop/settings/mac/).

```
             VirtioFS/FUSE/osxfs mount    directory      bind mount
macOS Host <=========================== Docker Desktop <============ Container
```

**On Windows with VirtualBox**, Docksal mounts **all** physical drives into the VM via SMB.

```
               SMB mount    directory     bind mount
Windows Host <=========== VirtualBox VM <============ Container
```

**On Windows with Docker Desktop**, Docker Desktop mounts **only** the configured drives via SMB.

```
               SMB mount    directory      bind mount
Windows Host <=========== Docker Desktop <============ Container
```

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=bind`, see
[stacks/volumes-bind.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-bind.yml).

In most cases, you do not need to set the `DOCKSAL_VOLUMES=bind` option. It is set for you automatically. The only
exception is when you need `fsnotify` events on macOS with Docker Desktop, but don't want to use the `unison` option.

### DOCKSAL_VOLUMES=nfs {#volumes-nfs}

This option is macOS specific. Docksal uses it by default with both VirtualBox and Docker Desktop.
Docker mounts the `project_root` volume from the host over NFS, then project containers can mount this volume.

```
             NFS mount      volume      volume mount
macOS Host <===========> project_root <============== Container
```

NFS generally works faster than any of the stock options available in Docker Desktop on macOS.
The downside is that NFS does not support `fsnotify` events (think "auto reloads"), while the stock options do.

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=nfs`, see
[stacks/volumes-nfs.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-nfs.yml).

### DOCKSAL_VOLUMES=none {#volumes-none}

This is an advanced option. It is used as the foundation for advanced and custom sync strategies.

The `project_root` volume is empty, not connected to a slow (stock Docker Desktop) / network (NFS, SMB) filesystem.
An external sync process must be used to sync files between the host and the volume.

Alternatively, files don't have to be synced at all. Instead, all operations get performed inside containers.

Paired with [VSCode IDE](/tools/ide/), this option can provide a way of provisioning instant blank
development environments with the best performance and consistency for Mac and Windows.

See [stacks/volumes-none.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-none.yml) for
details on Docker volumes definition with this option.

#### Using "none" Volumes

```bash
fin config set DOCKSAL_VOLUMES=none
fin project reset
```

Useful hints:

- use `fin bash` to log into the `cli` container, then download or checkout files with git
- use `fin docker cp` to copy files into the `cli` container from the host

### DOCKSAL_VOLUMES=unison {#volumes-unison}

- This is an advanced mode. It adds the automated "sync process" on top of the ["none"](#volumes-none) mode.  
- This mode only makes sense with Docker Desktop on macOS.

A `unison` container is added to the project stack with two volumes attached to it:

- the bind mount of the Docker Desktop mount from the host - slow, but supports `fsnotify`
- the `project_root` named volume - used by project containers (empty initially), gets native filesystem performance

The Unison daemon is responsible for syncing files between the two volumes/filesystems.

```
unison container   -------> VirtioFS/FUSE/osxfs mount from macOS host (w/ fsnotify)
  two-way sync     \
  between volumes   \
                      ----> project_root volume (native filesystem performance)
```

Project containers do not access files on the host directly, so there is no performance penalty for using 
VirtioFS/FUSE/osxfs or NFS for containers.

The benefits of this setup:

- Native container file system performance for codebase reads and writes
- Files are synced real-time both ways between the host and the `project_root` volume
- Support for filesystem watchers

The downsides:

- Initial sync can take time, especially on large codebases
- Higher disk space usage (double the size of the codebase)
- Additional CPU load from the Unison daemon

#### Using "unison" Volumes

```bash
fin config set DOCKSAL_VOLUMES=unison
fin project reset
```

Wait until the initial unison sync finishes.

{{% notice warning %}}
Switching volumes is a destructive operation for the whole project stack. To preserve the database state, it has to
be exported before and then imported back after switching volume modes.
{{% /notice %}}

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=unison` see
[stacks/volumes-unison.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-unison.yml).

### Mutagen {#volumes-mutagen}

- This is an advanced option. It adds the automated "sync process" on top of the ["none"](#volumes-none) option.
- This mode is similar to the [unison](#volumes-unison) mode, except Mutagen is used to sync files.
- This mode only makes sense with Docker Desktop on macOS.

There are two configuration and usage options:

- [Mutagen Extension for Docker Desktop](#volumes-mutagen-extension) - convenient, may require a paid subscription
- [Mutagen standalone](#volumes-mutagen-standalone) - open-source, free, configuration is more involved

#### Mutagen Extension for Docker Desktop {#volumes-mutagen-extension}

This is a turn-key option. It provides a nice GUI integration with Docker Desktop and thus is easier to use.

First, switch project volumes to `bind` mode (the extension expects "bind" volumes as the starting point):

```bash
fin config set DOCKSAL_VOLUMES=bind
fin project reset
```

Then, follow extension's setup and usage [instructions](https://mutagen.io/documentation/docker-desktop-extension).

{{% notice warning %}}
You can only remove the Mutagen single cache instance (free tier) after running `fin project remove` for a project.
{{% /notice %}}

#### Mutagen Standalone {#volumes-mutagen-standalone}

This option uses the open-source (and free) [Mutagen](https://github.com/mutagen-io/mutagen) version 
via the [nicoschi/mutagen-for-docksal](https://github.com/nicoschi/mutagen-for-docksal/) fin helper command.

First, install `mutagen` and the `fin mutagen` helper command:

```bash
brew install mutagen-io/mutagen/mutagen
mkdir -p ~/.docksal/commands
curl -fL# https://raw.githubusercontent.com/nicoschi/mutagen-for-docksal/master/mutagen -o ~/.docksal/commands/mutagen
chmod +x ~/.docksal/commands/mutagen
```

Then, follow the `mutagen` helper command usage [instructions](https://github.com/nicoschi/mutagen-for-docksal/#usage).

The initial synchronization takes several seconds depending on the amount of files in your project.

It is advisable to have the mutagen monitor running for mutagen, so you can see what it is doing at any given time
as sometimes it will be busy or need to be restarted if it reports errors. Start the Monitor and leave it running 
(in a separate terminal window) with

```bash
mutagen sync monitor -l
```

You can exclude certain paths from syncing (and thus keep them either on the host or in containers).
Good candidates to be excluded are VCS (`.git`/etc.) and vendored directories (`vendor`/`node_modules`/etc.).
Generally, if you exclude a directory from the project repo, you would also want to exclude it from mutagen sync.

Here's an example (`mutagen.yml`):

```yaml
sync:
  defaults:
    flushOnCreate: true
    ignore:
      vcs: false
      paths:
        - ".DS_Store"
        - "/.git/" # Only exclude the top level .git directory to ensure compatibility with some 3rd-party packages.
        - "node_modules/"
        - "vendor/"
    permissions:
      defaultFileMode: 644
      defaultDirectoryMode: 755
  myprojectname:
    alpha: "./"
    beta: "docker://docker@myprojectname_cli_1/var/www"
    mode: "two-way-resolved"
```

Run `fin mutagen restart` to apply configuration changes.

See mutagen [docs]](https://mutagen.io/documentation/synchronization/ignores) for more information.

{{% notice warning %}}
Switching volumes is a destructive operation for the whole project stack. To preserve the database state, it has to
be exported before and then imported back after switching volume modes.
{{% /notice %}}
