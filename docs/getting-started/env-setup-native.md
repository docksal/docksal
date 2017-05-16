# Using native Docker applications

On Mac and Windows, you can use native Docker applications instead of VirtualBox.

!!! danger "Experimental support"
    Docker for Mac/Windows support is experimental and is not recommended for regular use due to low filesystem performance.
    Please report any issues in the [issue queue](https://github.com/docksal/docksal/issues).


## Switching to Docker for Mac/Windows

**1.** Stop the Docksal VM (if applicable)

```bash
fin vm stop
```

**2.** Install Docker for [Mac](https://docs.docker.com/docker-for-mac) or [Windows](https://docs.docker.com/docker-for-windows).

**3.** Enable "native" apps mode.

Set `DOCKER_NATIVE=1` in `~/.docksal/docksal.env`

**4.** Install Docksal (unless already installed).

```bash
curl -fsSL get.docksal.io | sh
```

**5.** Reset Docksal system services.

```bash
fin reset system
```

## Switching back to VirtualBox

**1.** Close the "native" Docker app.

**2.** Disable "native" apps mode.

Remove `DOCKER_NATIVE=1` from `~/.docksal/docksal.env` 

**3.** Start Docksal VM and reset Docksal system services.

```bash
fin vm start
fin reset system
```
