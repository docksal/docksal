# Portable installation

Docksal can be installed from a USB drive or a local folder.  
This is useful for conferences/trainings/etc. where internet bandwidth is an issue.

Below is a list of dependencies required by Docksal to run:

- Babun and winpty (Windows only)
- `fin` and Docksal stack files
- VirtualBox (macOS and Windows only)
- boot2docker.iso (macOS and Windows only)
- Docker tools (docker cli, docker-compose, docker-machine)
- Docksal system service images
- Docksal stack images


## Creating a portable Docksal distribution

!!! warning
    A working Docksal 1.2.0+ (fin v1.6.0+) environment is required

The following one-liner can be used to pre-download most of the dependencies:

```bash
curl -fsSL get.docksal.io/portable | sh
```

Once downloaded, place the contents of the folder on a USB drive/etc and distribute as necessary.


## Installing from a portable source

!!! warning "Windows"
    Babun is included in the portable distribution, but has to be installed manually before proceeding.
    All further commands are expected to be run in Babun on Windows.

The official one-line installer supports portable mode installation and will detect and use local files when available.

Within the portable Docksal distribution folder run:

```bash
curl -fsSL get.docksal.io | sh
fin vm start
fin image load docksal-default-images.tar
```

!!! note
    A minimal internet connection is still necessary to pull `fin` and Docksal stack files (~150kB)

!!! note "Linux" 
    For Linux only system and stack images will be installed from a local source.
