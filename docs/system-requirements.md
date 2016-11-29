# System requirements

## Hardware

### CPU

Your CPU should support hardware **VT-x/AMD-V virtualization** (most modern CPUs) and it should be enabled in BIOS.

### RAM

On Mac/Windows 8GB is recommended for a comfortable development experience assuming that Docksal's virtual machine uses 1GB of RAM and other usual browser/IDE memory usages.  

RAM requirements on Linux are usually lower because no VM layer is required. You could run Docksal stack even on 512Mb linux workstation/virtual machine. For development purposes thought it's recommended to have at least 4GB RAM assuming usual browser/IDE memory usages.

## Software

While Docker is supported natively on Linux, Mac and Windows need a VM layer to run Docker containers.

There are two main options to get Docker containers running on Mac or Windows:

1) Docker Machine + [VirtualBox](https://www.virtualbox.org) 5.0+ (mature, battle-tested)  
2) Docker for [Mac](https://docs.docker.com/docker-for-mac)/[Windows](https://docs.docker.com/docker-for-windows) (newer, experimental)

Please refer to the [setup instructions](env-setup.md#setup) for further steps.
