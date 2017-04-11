# Using native Docker applications

On Mac and Windows, you can use native Docker applications instead of VirtualBox.

!!! danger "Experimental support"
    Docker for Mac/Windows support is experimental and is not recommended for regular use due to low filesystem performance.
    Please report any issues in the [issue queue](https://github.com/docksal/docksal/issues).

## Switching to Docker for Mac/Windows

**1.** Install Docker for [Mac](https://docs.docker.com/docker-for-mac) or [Windows](https://docs.docker.com/docker-for-windows).

**2.** Install `fin` and run `fin update`, unless already installed.

```bash
sudo curl -fsSL https://raw.githubusercontent.com/docksal/docksal/master/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
fin update
```

**3.** Tell Docksal to use native apps.

```bash
export DOCKER_NATIVE=1
```

This applies to a single terminal tab/session and has to be repeated for the new ones.
All further `fin` commands should be run within the same terminal tab/session.

**4.** Check and confirm the switch.

```bash
fin docker info | grep "Kernel Version"
```

If you see something like `Kernel Version: 4.4.27-moby` in the output,
then `fin` was able to communicate with your Docker for Mac/Windows instance.

**5.** Reset Docksal system containers.

```bash
fin reset system
```

## Switching to VirtualBox

**1.** Tell Docksal to use the default VirtualBox approach.

```bash
unset DOCKER_NATIVE
```

**2.** Check and confirm the switch.

```bash
fin docker info | grep "Kernel Version"
```

If you see:

- `Kernel Version: 4.4.27-boot2docker` this means you switched back to the VirtualBox VM (TinyCore, boot2docker.)
- `Kernel Version: 4.4.27-moby` this means you are still using Docker for Mac/Windows VM (Alpine Linux Moby.)

**3.** Reset Docksal system containers.

```bash
fin reset system
```
