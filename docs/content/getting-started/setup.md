---
title: "Installing Docksal"
weight: 1
aliases:
  - /en/master/getting-started/setup/
---

## System requirements

RAM requirement: 8GB or more.

### Mac

- Must be a 2010 or newer model
- macOS 10.11 or newer

### Linux

- CPU with SSE4.2 instruction set supported (most models released in the last 10 years)
- Supported distributions: Debian with derivatives (Ubuntu, Mint, etc.), Fedora with derivatives (CentOS etc.)


If you get output from the following command, then your CPU is good to go:

```bash
cat /proc/cpuinfo | grep sse4_2
``` 

Linux distros outside of the Debian and Fedora family may still work (e.g., Alpine). 
You will have to install Docker manually, then install Docksal as usual on [Linux](#install-linux).

### Windows

- CPU with hardware virtualization (**VT-x/AMD-V**) supported and [enabled in BIOS](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html).
- Windows 10 or newer


## Install Docksal {#install}

The installer script (`get.docksal.io`) requires administrative privileges to complete the installation. 

On all operating systems, `fin` cli tool is written to `/usr/local/bin` and Docksal's IP address (`192.168.64.100`) 
is assigned to the host's local network interface.

On macOS, `/etc/exports` and `/etc/resolver/docksal` have to be modified, and `nfsd` service has to be restarted. 

On Linux, installer (re)installs the Docker service if needed.

On Windows, there are additional requests for permissions to create network shares for local drives to share files with 
Docker and to mount them with the current user's account and password.

### Choose Operating System

Click your operating system to proceed to OS-tailored docs:

- [macOS](#install-macos)
- [Linux](#install-linux)
- [Windows](#install-windows)

### macOS Docker installation options {#install-macos} 

Click the preferred option to proceed to option-specific docs.

- [VirtualBox](#install-macos-virtualbox) ![Recommended](https://img.shields.io/badge/✔-Recommended-brightgreen.svg?classes=inline)
    - Faster, somewhat less convenient.
- [Docker for Mac](#install-macos-docker-for-mac)
    - Somewhat slower, but easier to use and update

### macOS with VirtualBox {#install-macos-virtualbox}

With this method, Docker will run inside a VM in VirtualBox.

1. Download and Install VirtualBox

    [![Download VirtualBox 5.2.20](https://img.shields.io/badge/⇩%20-Virtual%20Box%205.2.20-green.svg?classes=inline)](http://download.virtualbox.org/virtualbox/5.2.20/VirtualBox-5.2.20-125813-OSX.dmg)

1. Enable Kernel extension ([Why?](https://developer.apple.com/library/content/technotes/tn2459/_index.html))

    Go to `System Preferences > Security & Privacy`.  
    If you do not see the Allow button it means the extension is already enabled.

    ![Allowing VirtualBox kernel extension](/images/virtualbox-kernel-extension-allow.png)

1. Open Terminal app and run

        bash <(curl -fsSL https://get.docksal.io)


1. Start the VM

    In Terminal app run:

        fin vm start

### macOS with Docker for Mac {#install-macos-docker-for-mac}

1. Download and Install Docker for Mac

    [![Docker for Mac](https://img.shields.io/badge/⇩%20-Docker%20For%20Mac-green.svg?classes=inline)](https://download.docker.com/mac/stable/Docker.dmg)

1. Start Docker for Mac

    Wait until it says "Docker is running" in the menubar icon menu.

1. Open Terminal app and run

        DOCKER_NATIVE=1 bash <(curl -fsSL https://get.docksal.io)

### Linux installation options {#install-linux} 

Click your repo to proceed to docs.

- [Ubuntu](#install-linux-debian-fedora) 
- [Mint](#install-linux-debian-fedora) 
- [Debian](#install-linux-debian-fedora) 
- [Fedora](#install-linux-debian-fedora) 
- [CentOS](#install-linux-debian-fedora) 
- [Other distribution](#install-linux-other)

### Linux. Debian, Ubuntu, Fedora {#install-linux-debian-fedora}

Debian with all derivatives (Ubuntu, Raspbian etc.), Ubuntu with derivatives (Mint, etc.), 
and Fedora with derivatives are supported out of the box with automatic installation. 

1. Check pre-requisites

    By default, Apache listens on `0.0.0.0:80` and `0.0.0.0:443`. 
    This will prevent Docksal reverse proxy from running properly. 
    You can resolve it an any of the following ways:
      - Reconfigure Apache to listen on different host (e.g., `127.0.0.1:80` and `127.0.0.1:443`)
      - Reconfigure Apache to listen on different ports (e.g., `8080` and `4433`)
      - Stop and disable Apache

1. Check your software. 

    Check that you have installed and configured
    - curl
    - sudo
    
1. Open Terminal and run

        bash <(curl -fsSL https://get.docksal.io)

### Linux. Other distributions {#install-linux-other}

If you cannot find your distribution in the list above, it does not mean it is not supported! 
Lesser known Debian, Ubuntu, or Fedora derivatives are most likely supported.

This happens because Docker on Linux is being installed using the official [get.docker.com](https://get.docker.com) script.
If your distribution is not in the list above, but [get.docker.com](https://get.docker.com) supports it,
then it **is** supported too and you can [follow the steps for compatible distributions](#install-linux-debian-fedora).

In case your distribution in not compatible with [get.docker.com](https://get.docker.com), you will need to install 
latest stable Docker for your distribution first, and then [follow the steps for compatible distributions](#install-linux-debian-fedora).


### Windows Docker installation options {#install-windows} 

Click the preferred option to proceed to option-specific docs.

- [VirtualBox](#install-windows-virtualbox) ![Recommended](https://img.shields.io/badge/✔-Recommended-brightgreen.svg?classes=inline)
    - Use if your other VMs are in VirtualBox/Vagrant.
- [Docker for Windows](#install-windows-docker-for-windows)
    - Can be faster, but not compatible with VirtualBox (don't use if you have existing VMs in VirtualBox/Vagrant)  

### Windows and VirtualBox {#install-windows-virtualbox} 

1. Enable Windows Subsystem for Linux (WSL) support

    [![WSL](https://img.shields.io/badge/⇩%20-Windows%20Subsystem%20for%20Linux-green.svg?classes=inline)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

1. Install **Ubuntu 18.04** app from Microsoft Store 

    [![WSL](https://img.shields.io/badge/⇩%20-Ubuntu%2018.04%20App-green.svg?classes=inline)](https://www.microsoft.com/en-us/p/ubuntu-1804-lts/9n9tngvndl3q)

1. Install Docksal (VirtualBox will be installed automatically if necessary)

    Open **WSL** and run:

        bash <(curl -fsSL https://get.docksal.io)

1. Start Docksal

    In **WSL** run:

        fin system start

### Windows and Docker for Windows {#install-windows-docker-for-windows} 

1. Enable Windows Subsystem for Linux (WSL) support

    [![WSL](https://img.shields.io/badge/⇩%20-Windows%20Subsystem%20for%20Linux-green.svg?classes=inline)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

1. Install **Ubuntu 18.04** app from Microsoft Store

    [![WSL](https://img.shields.io/badge/⇩%20-Ubuntu%2018.04%20App-green.svg?classes=inline)](https://www.microsoft.com/en-us/p/ubuntu-1804-lts/9n9tngvndl3q)

1. Download and Install Docker for Windows

    [![Docker for Windows](https://img.shields.io/badge/⇩%20-Docker%20for%20Windows-green.svg?classes=inline)](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe)
    
1. Configure Docker for Windows

    Share your local drives with Docker for Windows:
    
    ![Sharing Windows drives with Docker](/images/docker-for-win-share-drives.png)

1. Install Docksal

    Open **WSL** and run:

        DOCKER_NATIVE=1 bash <(curl -fsSL https://get.docksal.io)


## Update Docksal {#updates}

All Docksal components can be updated with a single command:

```bash
fin update
```

## Uninstall Docksal {#uninstall}

### If you used VirtualBox 

The steps below will remove the Docksal VM and cleanup all Docksal stuff.

```bash
fin system stop
fin vm remove
rm -rf "$HOME/.docksal"
rm -f /usr/local/bin/fin
```

Optionally remove VirtualBox application.

### If you used Docker for Mac / Docker for Windows

The steps below will remove Docksal project containers (files untouched) 
and stop Docksal system services.

```bash
fin cleanup
fin system stop
rm -rf "$HOME/.docksal"
rm -f /usr/local/bin/fin
```

Optionally remove Docker for Mac / Docker for Windows application.

### If you used Linux

The steps below will remove Docksal project containers (files untouched) 
and stop Docksal system services.

```bash
fin cleanup
fin system stop
rm -rf "$HOME/.docksal"
rm -f /usr/local/bin/fin
```

Optionally follow Docker removal instructions for 
[Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/#uninstall-docker-ce), 
[Debian](https://docs.docker.com/install/linux/docker-ce/debian/#uninstall-docker-ce), 
[Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/#uninstall-docker-ce), 
[CentOS](https://docs.docker.com/install/linux/docker-ce/centos/#uninstall-docker-ce).
