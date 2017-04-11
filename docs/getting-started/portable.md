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

!!! note Linux 
    For Linux only system and stack images can be installed from a local source.

!!! note Windows
    Babun has to be downloaded and installed manually.

The following one-liner can be used to pre-download the rest of the dependencies:

```bash
curl -fsSL get.docksal.io/portable | sh
```

!!! important "Working Docksal environment required"
    This script relies on a working Docksal 1.2.0+ (fin v1.6.0+) environment and won't work otherwise.

Once downloaded, place the contents of the folder on a USB drive/etc.  
Install using the standard installer script, just make sure you run in inside the folder with the downloaded dependencies 
so they are detected and picked up by the installer:

```bash
curl -fsSL get.docksal.io | sh
```
