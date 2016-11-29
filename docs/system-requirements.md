# System requirements

## Hardware

### CPU

Your CPU should support hardware **VT-x/AMD-V virtualization** (most modern CPUs) and it should be enabled in BIOS.

### RAM

Workstation with 8GB is recommended for a comfortable development experience, although it's not a hard requirement. Docksal will run on a workstation with anything more than 1GB to accomodate Docksal's virtual machine (!GB RAM default) and host OS RAM usages. It was tested that Docksal runs on Windows 7 with 2GB RAM.

Linux RAM requirements are usually lower because no VM layer is required, so you could run Docksal stack even on 512MB Linux virtual machine. However for desktop development purposes recommendations above apply.

## Software

While Docker is supported natively on Linux, Mac and Windows need a VM layer to run Docker containers.

There are two main options to get Docker containers running on Mac or Windows:

1) Docker Machine + [VirtualBox](https://www.virtualbox.org) 5.0+ (mature, battle-tested)  
2) Docker for [Mac](https://docs.docker.com/docker-for-mac)/[Windows](https://docs.docker.com/docker-for-windows) (newer, experimental)

Please refer to the [setup instructions](env-setup.md#setup) for further steps.
