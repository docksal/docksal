# Docksal environment setup

**This is a one time setup.**  
Once you have a working Docksal environment in place, you can use it for all Docksal powered projects.

## Windows only

On Windows you will need a Linux-type shell.

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.  
Instructions were not tested with other shells on Windows.

Babun should be installed and run **as a regular user (do not use admin command prompt).**

## Setup

1) Install/update [VirtualBox](https://www.virtualbox.org) (**Mac and Windows only**)  
2) Install/update `fin` (Docksal command-line tool)

```
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

3) Install/update tools and configurations

```
fin update
```


## Support for Docker for Mac/Windows

Docker for Mac/Windows support is experimental. Please report any issues in the [issue queue](https://github.com/docksal/docksal/issues)

To try it out:

1) Install Docker for [Mac](https://docs.docker.com/docker-for-mac) or [Windows](https://docs.docker.com/docker-for-windows)  
2) Install `fin` and run `fin update` (unless already installed)

```
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
fin update
```

3) Run `export DOCKER_NATIVE=1` in your terminal

This applies to a single terminal tab/session and has to be repeated for new ones).
All further `fin` commands should be run within the same terminal tab/session. 

4) Run `fin docker info | grep "Kernel Version"`

If you see something like `Kernel Version: 4.4.27-moby` in the output, 
then `fin` was able to communicate with your Docker for Mac/Windows instance.

5) Run `fin reset system` 

To switch back to Docker Machine + VirtualBox setup:

1) `unset DOCKER_NATIVE`
2) `fin reset system`

This will reset system services and update DNS resolution for .docksal domains (Mac)

3) Run `fin docker info | grep "Kernel Version"`

`Kernel Version: 4.4.27-boot2docker` means you switched back to the VirtualBox VM (TinyCore, boot2docker)
`Kernel Version: 4.4.27-moby` means you are still using Docker for Mac/Windows VM (Alpine Linux Moby)
