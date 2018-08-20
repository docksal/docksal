# Installing Docksal

## System requirements

Minimum RAM requirement: 4GB. 8GB or more recommended.

### Mac

- Must be a 2010 or newer model
- macOS 10.11 or newer

### Linux

- CPU should support hardware **VT-x/AMD-V virtualization** and it should be [enabled in BIOS](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html).
- Supported distributions: Debian with derivatives (Ubuntu, Mint, etc.), Fedora with derivatives (CentOS etc.)
- From Docksal version 1.10.0 and greater netplan is required for non-persistent network configuration on Linux used in Docksal.

### Windows

- CPU should support hardware **VT-x/AMD-V virtualization** and it should be [enabled in BIOS](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html).
- Windows 7 or newer

<a name="install"></a>
## Installation

### Choose Operating System

Click your operating system to proceed to OS-tailored docs:

- [macOS](#install-macos)
- [Linux](#install-linux)
- [Windows](#install-windows)

<a name="install-macos"></a>
### macOS Docker installation options 

Click the preferred option to proceed to option-specific docs.

- [VirtualBox](#install-macos-virtualbox) ![Recommended](https://img.shields.io/badge/✔-Recommended-brightgreen.svg)
    - Faster, somewhat less convenient.
- [Docker for Mac](#install-macos-docker-for-mac)
    - Somewhat slower, but easier to use and update

<a name="install-macos-virtualbox"></a>
### macOS with VirtualBox

With this method, Docker will run inside the VM in VirtualBox.

1. Download and Install VirtualBox

    [![Download VirtualBox 5.2.2](https://img.shields.io/badge/⇩%20-Virtual%20Box%205.2.2-green.svg)](http://download.virtualbox.org/virtualbox/5.2.2/VirtualBox-5.2.2-119230-OSX.dmg)

1. Enable Kernel extension ([Why?](https://developer.apple.com/library/content/technotes/tn2459/_index.html))

    Go to `System Preferences > Security & Privacy`.  
    If you do not see the Allow button it means the extension is already enabled.

    ![Allowing VirtualBox kernel extension](../_img/virtualbox-kernel-extension-allow.png)

1. Open Terminal app and run

        curl -fsSL get.docksal.io | bash


1. Start the VM

    In Terminal app run:

        fin vm start

<a name="install-macos-docker-for-mac"></a>
### macOS with Docker for Mac

1. Download and Install Docker for Mac

    [![Docker for Mac](https://img.shields.io/badge/⇩%20-Docker%20For%20Mac-green.svg)](https://download.docker.com/mac/stable/Docker.dmg)

1. Start Docker for Mac

    Wait until it says "Docker is running" in the menubar icon menu.

1. Open Terminal app and run

        curl -fsSL get.docksal.io | DOCKER_NATIVE=1 bash

<a name="install-linux"></a>
### Linux installation options 

Click your repo to proceed to docs.

- [Ubuntu](#install-linux-debian-fedora) 
- [Mint](#install-linux-debian-fedora) 
- [Debian](#install-linux-debian-fedora) 
- [Fedora](#install-linux-debian-fedora) 
- [CentOS](#install-linux-debian-fedora) 
- [Other distribution](#install-linux-other)

<a name="install-linux-debian-fedora"></a>
### Linux. Debian, Ubuntu, Fedora.

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

        curl -fsSL get.docksal.io | bash

<a name="install-linux-other"></a>
### Linux. Other distributions

#### Compatibility

If you cannot find your distribution in the list above, it does not mean it is not supported! 
Lesser known Debian, Ubuntu, or Fedora derivatives are most likely supported.

This happens because Docker on Linux is being installed using the official [get.docker.com](https://get.docker.com) script.
If your distribution is not in the list above, but [get.docker.com](https://get.docker.com) supports it,
then it **is** supported too and you can [follow the steps for compatible distributions](#install-linux-debian-fedora).

#### Incompatible distributions

In case your distribution in not compatible with [get.docker.com](https://get.docker.com), you will need to install 
latest stable Docker for your distribution first, and then [follow the steps for compatible distributions](#install-linux-debian-fedora).

<a name="install-windows"></a>
### Windows. Linux Shell installation options 

Docksal on Windows requires Linux type shell to run. Choose the options you like.

- [Babun](#install-windows-babun) ![Recommended](https://img.shields.io/badge/✔-Recommended-brightgreen.svg)
    - Faster install, but CYGWIN is less native.
- [Ubuntu Application (WSL)](#install-windows-wsl)
    - **Beta.** Harder to install, can ony use Docker for Mac, but native Linux shell, real Ubuntu on Windows.

<a name="install-windows-babun"></a>
### Windows with Babun. Docker installation options 

Using Babun as Linux type shell supports 2 options of Docker installation.

- [VirtualBox](#install-windows-babun-virtualbox) ![Recommended](https://img.shields.io/badge/✔-Recommended-brightgreen.svg)
    - Faster, somewhat less convenient to use and update.
- [Docker for Windows](#install-windows-babun-docker-for-windows)
    - Somewhat slower, excludes VirtualBox, but easier to use and update

<a name="install-windows-babun-virtualbox"></a>
### Windows with Babun and VirtualBox 

1. Download and Install Babun

    [![Babun Site](https://img.shields.io/badge/↪%20-Babun%20Site-blue.svg)](http://babun.github.io/)

1. Windows 10. Enable SMB1 protocol ([Why?](https://docs.docksal.io/en/master/troubleshooting-smb/#windows-10-fall-creators-update-1709))

    This step will require reboot. On Windows 10 open Windows Command Prompt as  Administrator and run:

        dism /online /enable-feature /all /featurename:SMB1Protocol-Server

1. Install Docksal

    Open **Babun** and run:

        curl -fsSL get.docksal.io | bash

1. Start the VM

    In **Babun** run:

        fin vm start

<a name="install-windows-babun-docker-for-windows"></a>
### Windows with Babun and Docker for Windows 

1. Download and Install Babun

    [![Babun Site](https://img.shields.io/badge/↪%20-Babun%20Site-blue.svg)](http://babun.github.io/)

1. Download and Install Docker for Windows

    [![Docker for Windows](https://img.shields.io/badge/⇩%20-Docker%20for%20Windows-green.svg)](http://download.virtualbox.org/virtualbox/5.2.2/VirtualBox-5.2.2-119230-OSX.dmg)
    
    Notes: computer will require logout and restart during the installation. 
    [See screen recording](https://youtu.be/bQgaEUcuJ98) to know what to expect.

1. Configure Docker for Windows

    Share your local drives with Docker for Windows:
    
    ![Sharing Windows drives with Docker](../_img/docker-for-win-share-drives.png)

1. Install Docksal

    Open **Babun** and run:

        curl -fsSL get.docksal.io | bash

<a name="install-windows-wsl"></a>
### Windows with Ubuntu App (WSL) and Docker for Windows 

Warning: this way of using Docksal is not thoroughly tested. 
It has been proven to work, but quirks may happen.

Ubuntu application is previously known as Windows Subsystem for Linux (WSL)

1. Install Ubuntu App
    
    - [Video: install Ubuntu App on Wndows 10 [Part 1/2]](https://www.youtube.com/watch?v=2Mk_wprFpzQ)  
    - [Video: install Ubuntu App on Wndows 10 [Part 2/2]](https://www.youtube.com/watch?v=44UCMVZQT80)  

1. Install and configure Docker for Windows

    - [Video: installing and configuring Docker for Windows](https://www.youtube.com/watch?v=bQgaEUcuJ98)

1. Install Docksal

    - [Video: installing Docksal into Ubuntu App on Windows 10](https://www.youtube.com/watch?v=FJBN9-dGhyc)

<a name="updates"></a>
# Updating Docksal

All Docksal components can be updated with a single command:

```bash
fin update
```

<a name="uninstall"></a>
# Uninstallation

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

Optionally follow Docker uninstallation instructions for 
[Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/#uninstall-docker-ce), 
[Debian](https://docs.docker.com/install/linux/docker-ce/debian/#uninstall-docker-ce), 
[Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/#uninstall-docker-ce), 
[CentOS](https://docs.docker.com/install/linux/docker-ce/centos/#uninstall-docker-ce).
