# System requirements

## CPU

- (**Mac**) Must be a 2010 or newer model
- (**PC**) Your CPU should support hardware **VT-x/AMD-V virtualization** and it should be [enabled in BIOS](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Virtualization_Administration_Guide/sect-Virtualization-Troubleshooting-Enabling_Intel_VT_and_AMD_V_virtualization_hardware_extensions_in_BIOS.html).

!!! note "Windows Users: Are you planning on running VirtualBox?"
    If you plan on using the VirtualBox installation instead of Docker for Windows? If your machine supports it
    Hyper-V *must* be shut off in order for the continue with the installation. By default it is turned off but if it
    isn't then you will receive a similar message like below:

    _Error with pre-create check: "This computer is running Hyper-V. VirtualBox won't boot a 64bits VM when Hyper-V is
    activated. Either use Hyper-V as a driver, or disable the Hyper-V hypervisor.
    (To skip this check, use --virtualbox-no-vtx-check)_

## RAM

- (**Mac/Win**) Workstation with 4GB is required (8GB recommended)
- (**Linux**) no minimum requirement (4GB recommended)

## Software

- 64-bit OS is required for all platforms
- (**Mac**) OS X El Capitan 10.11 or newer
- (**Mac**) VirtualBox prior to version 4.3.30 must NOT be installed
- (**Win**) Windows 7 or newer
- (**Linux**) Ubuntu Linux 14.04 or newer (or it's derivatives) with Linux kernel 3.10 or newer


Refer to the [environment setup instructions](../getting-started/env-setup.md) for further steps.
