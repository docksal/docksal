# Docksal environment setup

!!! important "This is a one time setup"
    Once you have a working Docksal environment in place, you can use it for all Docksal powered projects.

## Windows only

On Windows you will need a Linux-type shell.

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.  
Instructions were not tested with other shells on Windows.

!!! danger "Install as regular user"
    Babun should be installed and run **as a regular user (do not use admin command prompt).**

## Installation

#### 1. (Mac/Win) Install VirtualBox 

Install [VirtualBox 5.1.2 Mac](http://download.virtualbox.org/virtualbox/5.1.2/VirtualBox-5.1.2-108956-OSX.dmg)/[VirtualBox 5.1.2 Win](http://download.virtualbox.org/virtualbox/5.1.2/VirtualBox-5.1.2-108956-Win.exe) 

!!! attention "Specific version required!"
    **Please note that specific version is important.** If you're using different version it can work fine or you can experience unforeseen bugs. `fin` will notify you about a need to update your VirtualBox version in future.

#### 2. Install `fin`

```
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

#### 3. Install tools and configurations

```
fin update
```

#### 4. (Mac/Win) Create and start vm

```
fin vm start
```

[Help, my VM did not start!](/docs/troubleshooting.md#failed-creating-docksal-virtual-machine)

#### 5. Congratulations! 

You are done with one time environment installation. Now you can [configure your project](/docs/project-setup.md) to use Docksal or create a new pre-configured Drupal or Wordpress project with `fin create-site`.

## Using Docker for Mac/Windows instead of VirtualBox

!!! danger "Experimental support"
    Docker for Mac/Windows support is experimental and is not recommended for regular use due to low filesystem performance. Please report any issues in the [issue queue](https://github.com/docksal/docksal/issues)

#### Switching to native Docker application for Mac/Window

**1.** Install Docker for [Mac](https://docs.docker.com/docker-for-mac) or [Windows](https://docs.docker.com/docker-for-windows)  
**2.** Install `fin` and run `fin update` (unless already installed)

```
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
fin update
```

**3.** Run `export DOCKER_NATIVE=1` in your terminal

This applies to a single terminal tab/session and has to be repeated for new ones).
All further `fin` commands should be run within the same terminal tab/session. 

**4.** Run `fin docker info | grep "Kernel Version"`

If you see something like `Kernel Version: 4.4.27-moby` in the output, 
then `fin` was able to communicate with your Docker for Mac/Windows instance.

**5.** Run `fin reset system` 

#### Switching back to VirtualBox

**1.** `unset DOCKER_NATIVE`

**2.** `fin reset system`

This will reset system services and update DNS resolution for .docksal domains (Mac)

**3.** Run `fin docker info | grep "Kernel Version"`

`Kernel Version: 4.4.27-boot2docker` means you switched back to the VirtualBox VM (TinyCore, boot2docker)
`Kernel Version: 4.4.27-moby` means you are still using Docker for Mac/Windows VM (Alpine Linux Moby)
