---
title: "Shared Volumes"
weight: 3
aliases:
  - /en/master/advanced/volumes/
---

## Quick Overview {#overview}

| OS      | VM              | DOCKSAL_VOLUMES             | FS Speed | FS Events | Comments  |
|---------|-----------------|-----------------------------|-------   |-----------|-----------|
| Linux   | -               | [bind](#volumes-bind) (**default**) | 100%     | Yes       | Direct host files access, maximum filesystem speed. |
| macOS   | VirtualBox      | [nfs](#volumes-nfs) (**default**)   | 80%      |           | Uses `nfs` for best overall for macOS. Stable, lightweight. |
| macOS   | Docker Desktop  | [nfs](#volumes-nfs) (**default**)   | 80%      |           | Uses `nfs` for best overall for macOS. Stable, lightweight. |
| macOS   | Docker Desktop  | [bind](#volumes-bind)               | 60%      | Yes       | Uses `osxfs`. Can cause higher CPU usage. |
| macOS   | Docker Desktop  | [unison](#volumes-unison)           | 100%     | Yes       | Uses `osxfs`. Can be unstable, especially on large codebases. |
| macOS   | Docker Desktop  | [mutagen](#volumes-mutagen)         | 100%     | Yes       | Uses `mutagen`. Needs monitoring and ramp up. |
| Windows | ANY             | [bind](#volumes-bind) (**default**) | 50%      |           | Uses `SMB` - the only option for Windows. |
| ANY     | ANY             | [none](#volumes-none)               | 100%     |           | Work on the codebase has to be done inside the `cli` container. |


## Project Volumes

If you are familiar with Docker Compose, then you must have attached files or dirs like this:

```yaml
  cli:
    volumes:
      - /Users/alex/mysite:/var/www:rw
```

That is a called a bind mount - mounting a file/folder directly into a container.
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
Switching volumes is a destructive operation for the whole project stack. To preserve the current state of the database,
it has to be exported before it is changed and then imported back.
{{% /notice %}}

See the table in the [overview](#overview) section for appropriate values based on OS/VM environment.

To check the current value, run `fin config get DOCKSAL_VOLUMES` / `fin config get --global DOCKSAL_VOLUMES`

### DOCKSAL_VOLUMES=bind {#volumes-bind}

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

In most cases, you do not need to set the `DOCKSAL_VOLUMES=bind` option. It is set for you automatically. The only
exception is when you need `fsnotify` events on macOS with Docker Desktop, but don't want to use the `unison` option.

### DOCKSAL_VOLUMES=nfs {#volumes-nfs}

This option is macOS specific and is used by default with both VirtualBox and Docker Desktop.
Docker mounts the `project_root` volume from the host over NFS, then project containers mount this volume.

```
            volume mounted via NFS
macOS Host ========================> Container
```

NFS generally works faster than `osxfs`. The downside is that NFS does not support `fsnotify` events.

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=nfs`, see
[stacks/volumes-nfs.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-nfs.yml).

### DOCKSAL_VOLUMES=unison {#volumes-unison}

This option only makes sense with Docker Desktop on macOS.

A `unison` container is added to the project stack with two volumes attached to it:

- a bind mount of the osxfs mount from the host - slow, but supports `fsnotify`
- a `project_root` named volume - native filesystem performance for containers (empty initially)

```
            osxfs                   bind                      volume
macOS Host =======> Docker Desktop ======> unison container <======== project_root
```

The Unison daemon is responsible for syncing files between the two volumes.

```
unison container   -------> osxfs mount from macOS host (w/ fsnotify)
  two-way sync     \
  between volumes   \
                      ---> project_root volume
```

Project containers do not access files on the host directly, so there is no performance penalty of using osxfs or NFS
for containers.

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
```

Wait until the initial unison sync finishes.

{{% notice warning %}}
Switching volumes is a destructive operation for the whole project stack. To preserve the current state of the database,
it has to be exported before it is changed and then imported back.
{{% /notice %}}

To see how your project's Docker volumes are defined with `DOCKSAL_VOLUMES=unison` see
[stacks/volumes-unison.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-unison.yml).

### DOCKSAL_VOLUMES=none {#volumes-none}

Advanced option. With this option, host files are made accessible to the VM like in a bind mount, but after that
containers do not access them directly via bind, nor files are copied over.
You would have to copy files into container and back manually.

Combined with [VSCode IDE](/tools/ide/), this option can provide a way of provisioning instant blank
development environments with the best performance and consistency for Mac and Windows.
The only added cost is having to stick with a browser-based IDE and terminal for developer UX.

See [stacks/volumes-none.yml](https://github.com/docksal/docksal/blob/master/stacks/volumes-none.yml) for
details on Docker volumes definition with this option.

#### Using "none" Volumes

```bash
fin config set DOCKSAL_VOLUMES=none
fin project reset
```

Use `fin bash` to log into bash and checkout files into `/var/www` with git. Or use `fin docker cp` to copy
files into the `cli` container.

### Mutagen {#volumes-mutagen}

- This option only makes sense with Docker Desktop on macOS.
- Like the Unison option, Mutagen is used to synchronize the files from host to the container.
- There are two configuration and usage options for Mutagen: Docker Desktop Extension and Stand alone.

#### The Docker Desktop Extension

- [The Paid Subscription](https://mutagen.io/account/subscription $7/month) which allows for multiple cache directory setups.
- The Docker Desktop Extension provides a nice GUI integration with Docker Desktop and thus the maintenance of it is easier.
- To use it run

```bash
fin config set DOCKSAL_VOLUMES=bind
docker extension install mutagenio/docker-desktop-extension:latest
docker context use desktop-linux-mutagen
fin project reset
```

  - Then create the [cache as instructed](https://mutagen.io/documentation/docker-desktop-extension)
  - Please note that although you set "DOCKSAL_VOLUMES" to "bind", it is automatically switched when you run the extension.
  - Also, you can only remove the single cache instance after you have `fin project remove` your project.

#### The Stand Alone Mutagen version

- This option allows for as many sync sessions as you would like and is free. ( https://github.com/mutagen-io/mutagen )
- Setup and install as follows:
  - Create a mutagen.yml configuration file in your project directory with contents like:

```yaml
sync:
  defaults:
    flushOnCreate: true
    ignore:
      vcs: false
      paths:
        - "node_modules"
        - "*.sql"
        - "*.sql.gz"
        - "/private/"
        - ".history/" # vsCode local history
        - ".tags"
        - "artifact_deploy"
        - ".git"
        - "mutagen*"
        - ".gitignore"
        - "README*"
        - ".eslint*"
        - ".editor*"
        - ".gitattributes"
        - ".vscode"
        - "deployment_identifier"
        - "salt.txt"
        - ".acquia-cli.yml"
        - "phpcs.xml"
        - "/hooks/"
        - "/patches/"
        - ".gitlab-ci.yml"
        - ".DS_Store"
    permissions:
      defaultFileMode: 644
      defaultDirectoryMode: 755
  myprojectname:
    alpha: "./"
    beta: "docker://docker@myprojectname_cli_1/var/www"
    mode: "two-way-resolved"
```

- Replace 'myprojectname' (two instances) with the name of your project in the mutagen.yml file.
- Run the following:

```bash
brew install mutagen-io/mutagen/mutagen
fin config set DOCKSAL_VOLUMES=none
fin config set MUTAGEN=1
fin project reset
curl https://raw.githubusercontent.com/nicoschi/mutagen-for-docksal/master/mutagen > .docksal/commands/mutagen
chmod +x .docksal/commands/mutagen
fin mutagen start
fin db import your_db_backup.sql
```

- The initial synchronization takes several seconds depending on the amount of files in your project.
- The database import command is necessary since you have now done a "project reset".
- It is advisable to have the mutagen monitor running for mutagen so you can see what it is doing at any given time as sometimes
  it will be busy or need to be restarted if it reports errors.
- Start the Monitor and leave it running (in a seperate terminal window) with

```bash
mutagen sync monitor -l
```

If you [need to restart your project](https://github.com/nicoschi/mutagen-for-docksal/#usage), do it with
the mutagen helper:

```bash
fin mutagen restart
```

- We believe this is the fastest option available for the MacOs.
- Read documentation on the [different mutagen commands](https://mutagen.io/documentation/introduction/getting-started#session-management)

{{% notice warning %}}
Switching volumes is a destructive operation for the whole project stack. To preserve the current state of the database,
it has to be exported before it is changed and then imported back.
{{% /notice %}}

