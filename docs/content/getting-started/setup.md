---
title: "Install Docksal"
weight: 1
aliases:
  - /en/master/getting-started/setup/
---

## System requirements

RAM requirement: 8GB or more.

### Mac

Must be a 2010 or newer model.


### Linux

CPU with SSE4.2 instruction set supported (most CPUs). If you get output from the following command, then your CPU is good to go:

```bash
cat /proc/cpuinfo | grep sse4_2
``` 

### Windows

Windows 10 and CPU with hardware virtualization (**VT-x/AMD-V**) supported and [enabled in BIOS](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html).


## Install Docksal {#install}

### Administrative Privileges

{{% notice note %}}
The installer script (`get.docksal.io`) requires administrative privileges to complete the installation. 
{{% /notice %}}

Here's why:

- All systems: `fin` cli tool is written to `/usr/local/bin` (all systems)
- All systems: `192.168.64.100` (Docksal's canonical IP) is assigned to the host's local network interface (all systems) 
- macOS: `/etc/exports` and `/etc/resolver/docksal` have to be modified, `nfsd` service has to be restarted
- Linux: install/update the Docker service if necessary
- Windows: there are additional requests for permissions to create network shares for local drives to share files with 
Docker and to mount them with the current user's account and password.


### What is your operating system?

Click to jump to OS-tailored docs:

- [macOS](#install-macos)
- [Linux](#install-linux)
- [Windows](#install-windows)

### macOS installation options {#install-macos} 

Click the preferred option to proceed to option-specific docs.

- [Docker Desktop](#install-macos-docker-for-mac) ![Recommended](https://img.shields.io/badge/✔-Recommended-brightgreen.svg?classes=inline)
    - Easier to use
- [VirtualBox](#install-macos-virtualbox)
    - Old school style

### macOS with VirtualBox {#install-macos-virtualbox}

With this method, Docker will run inside a VM in VirtualBox.

1. Install VirtualBox v5.2.32

    [![Download VirtualBox v5.2.32](https://img.shields.io/badge/download-VirtualBox%20for%20Mac-blue.svg?logo=dropbox&style=for-the-badge&classes=inline)](http://download.virtualbox.org/virtualbox/5.2.32/VirtualBox-5.2.32-132073-OSX.dmg)

1. Enable Kernel extension ([Why?](https://developer.apple.com/library/content/technotes/tn2459/_index.html))

    Go to `System Preferences > Security & Privacy`.  
    If you do not see the Allow button it means the extension is already enabled.

    ![Allowing VirtualBox kernel extension](/images/virtualbox-kernel-extension-allow.png)

1. Open Terminal app and run

        bash <(curl -fsSL https://get.docksal.io)

1. Start Docksal

        fin system start

### macOS with Docker Desktop {#install-macos-docker-for-mac}

{{% notice warning %}}
Docker Desktop v2.2.0.0+ versions introduced a regression that breaks Docksal. Please refrain from updating and stick 
with the version linked below.
{{% /notice %}}

1. Install Docker Desktop for Mac v2.1.0.3

    [![Docker Desktop for Mac v2.1.0.3](https://img.shields.io/badge/download-Docker%20Desktop%20for%20Mac-blue.svg?logo=docker&style=for-the-badge&classes=inline)](https://download.docker.com/mac/stable/38240/Docker.dmg) <!-- when changing this version please change https://github.com/docksal/docksal.io/tree/master/src/pages/installation.js as well -->

1. Start Docker Desktop

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

### Linux. Debian, Ubuntu, and Fedora distributions {#install-linux-debian-fedora}

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


### Windows installation options {#install-windows} 

Click the preferred option to proceed to option-specific docs.

- [VirtualBox](#install-windows-virtualbox) ![Recommended](https://img.shields.io/badge/✔-Recommended-brightgreen.svg?classes=inline)
    - Faster, allows launching Vagrant alongside.
- [Docker Desktop](#install-windows-docker-for-windows)
    - Easier to use. Do not use if you have existing Vagrant projects or VirtualBox VMs  

### Windows and VirtualBox {#install-windows-virtualbox} 

1. Enable Windows Subsystem for Linux (WSL) support

    [![Enabling WSL](https://img.shields.io/badge/Windows%20Subsystem%20for%20Linux-blue.svg?logo=windows&style=for-the-badge&classes=inline)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

1. Install **Ubuntu 18.04** app from Microsoft Store 

    [![Ubuntu App for Windows](https://img.shields.io/badge/Ubuntu%2018.04%20App-orange.svg?logo=ubuntu&style=for-the-badge&classes=inline)](https://www.microsoft.com/en-us/p/ubuntu-1804-lts/9n9tngvndl3q)

1. Install Docksal (VirtualBox will be installed automatically if necessary)

    Open **Ubuntu** shell and run:

        bash <(curl -fsSL https://get.docksal.io)

1. Start Docksal

    In **Ubuntu** shell run:

        fin system start

### Windows and Docker Desktop {#install-windows-docker-for-windows} 

{{% notice warning %}}
Docker Desktop v2.2.0.0+ versions introduced a regression that breaks Docksal. Please refrain from updating and stick 
with the version linked below.
{{% /notice %}}

1. Enable Windows Subsystem for Linux (WSL) support

    [![Enabling WSL](https://img.shields.io/badge/Windows%20Subsystem%20for%20Linux-blue.svg?logo=windows&style=for-the-badge&classes=inline)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

2. Install **Ubuntu 18.04** app from Microsoft Store

    [![Ubuntu App for Windows](https://img.shields.io/badge/Ubuntu%2018.04%20App-orange.svg?logo=ubuntu&style=for-the-badge&classes=inline)](https://www.microsoft.com/en-us/p/ubuntu-1804-lts/9n9tngvndl3q)

3. Install Docker Desktop for Windows v2.1.0.3

    [![Docker Desktop for Windows v2.1.0.3](https://img.shields.io/badge/download-Docker%20Desktop%20for%20Windows-blue.svg?logo=docker&style=for-the-badge&classes=inline)](https://download.docker.com/win/stable/38240/Docker%20Desktop%20Installer.exe) <!-- when changing this version please change https://github.com/docksal/docksal.io/tree/master/src/pages/installation.js as well -->
    
4. Configure Docker Desktop on Windows

    4.1. Share your local drives with Docker for Windows:
    
    ![Share your Windows drives with Docker Desktop](/images/docker-for-win-share-drives.png)
    
    4.2. Share Docker Desktop port to the local network:
    
    ![Expose Docker daemon on tcp://localhost:2375 without TLS](/images/docker-for-win-expose-network.png)

5. Install Docksal

    Open **Ubuntu** shell and run:

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

Optionally, remove VirtualBox application.

### If you used Docker Desktop

The steps below will remove Docksal project containers (files untouched) 
and stop Docksal system services.

```bash
fin cleanup
fin system stop
rm -rf "$HOME/.docksal"
rm -f /usr/local/bin/fin
```

Optionally, uninstall Docker Desktop.

### If you used Linux

The steps below will remove Docksal project containers (files untouched) 
and stop Docksal system services.

```bash
fin cleanup
fin system stop
rm -rf "$HOME/.docksal"
rm -f /usr/local/bin/fin
```

Optionally, follow Docker removal instructions for 
[Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/#uninstall-docker-ce), 
[Debian](https://docs.docker.com/install/linux/docker-ce/debian/#uninstall-docker-ce), 
[Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/#uninstall-docker-ce), 
[CentOS](https://docs.docker.com/install/linux/docker-ce/centos/#uninstall-docker-ce).
