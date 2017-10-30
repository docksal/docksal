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
curl -fsSL https://get.docksal.io | sh
```

**5.** Reset Docksal system services.

```bash
fin reset system
```

**6.** Configure file sharing as necessary (see below).


### File sharing

Docker for Mac automatically shares most commonly used volumes/directories. 
See [here](https://docs.docker.com/docker-for-mac/#file-sharing) for details.  
It is usually not necessary to adjust these settings.

Docker for Windows does NOT share drives automatically. This has to be done manually. 
See [here](https://docs.docker.com/docker-for-windows/#shared-drives) for details.  
Configure sharing for the drive where your "Projects" folder is (`C:` in most cases).


## Switching back to VirtualBox

**1.** Close the "native" Docker app.

**2.** Disable "native" apps mode.

Remove `DOCKER_NATIVE=1` from `~/.docksal/docksal.env` 

**3.** Reset networks settings, start Docksal VM and reset Docksal system services.

```bash
fin reset network
fin vm start
fin reset system
```
