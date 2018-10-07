---
title: "Portable installation"
weight: 4
---

Docksal can be installed from a USB drive or a local folder.  
This is useful for conferences/trainings/etc. where internet bandwidth is an issue.

<a name="download"></a>
## Creating a portable Docksal distribution

{{% notice note %}}
A working Docksal 1.2.0+ (fin v1.6.0+) environment is required
{{% /notice %}}

### One-line download script

The following download script can be used to pre-download most of the dependencies and Docker images..

```bash
curl -fsSL https://get.docksal.io/portable | sh
```

Here's is what the script will download:

- Babun and winpty (necessary for Windows only)
- VirtualBox and boot2docker.iso (necessary for macOS and Windows)
- Docker tools: docker cli, docker-compose, docker-machine (macOS and Windows versions)
- Docksal system and default stack images (these are cross-platform)

The following download options are available:

- `SKIP_DEPS` - skip downloading dependencies (use if you plan to use the native Docker for Mac/Win apps or Linux) 
- `SKIP_IMAGES` - skip pulling and saving Docker images

Example:

```bash
curl -fsSL https://get.docksal.io/portable | SKIP_DEPS=1 sh
```

Once downloaded, place the contents of the folder on a USB drive/etc and distribute.

### Custom stacks

If you plan on using a custom stack configuration, you will have a to export the project images manually.

You can export both system and project images by running the following within a Docksal project folder:

```bash
fin image save --system
fin image save --project
```

This will created two files: `docksal-system-images.tar` and `docksal-<project-name>-images.tar`.  
Instruct users to use the latter file instead of `docksal-default-images.tar` when loading stack images (see below).

### Docker for Mac/Windows

Manually download Docker for Mac/Windows apps into the portable distribution folder:

- [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)
- [Docker for Windows](https://docs.docker.com/docker-for-windows/install/)


<a name="install"></a>
## Installing from a portable source

{{% notice note %}}
Babun is included in the portable distribution, but has to be installed manually before proceeding.
All further commands are expected to be run in Babun on Windows.
{{% /notice %}}

Docksal's one-line installer supports portable mode installation and will detect and use local files when available.

<a name="install-virtualbox"></a>
### Mac and Windows (using VirtualBox)

{{% notice note %}}
This is the recommended setup option.
{{% /notice %}}

{{% notice note %}}
A minimal internet connection is still necessary to pull `fin` and Docksal stack files (~150kB).
{{% /notice %}}

Within the portable Docksal distribution folder run:

```bash
curl -fsSL https://get.docksal.io | sh
fin vm start
fin image load docksal-default-images.tar
```

<a name="install-native"></a>
### Docker for Mac/Windows ("native" mode)

{{% notice note %}}
Consider reviewing the [docs](docker-modes.md) on switching between "native" applications and VirtualBox.
{{% /notice %}}

Install the corresponding Docker app for your OS from the provided portable distribution. 
Start the app and wait until Docker says it's running.

Within the portable Docksal distribution folder run:

```bash
curl -fsSL https://get.docksal.io | DOCKER_NATIVE=1 sh
fin image load docksal-default-images.tar
```

<a name="install-linux"></a>
### Linux

{{% notice warning %}}
Only Docksal system and stack images will be installed from the portable source.
All other Docker dependencies and tools will be downloaded from internet (you will need a decent internet connection).
{{% /notice %}}

Within the portable Docksal distribution folder run:

```bash
curl -fsSL https://get.docksal.io | sh
fin image load docksal-default-images.tar
```
