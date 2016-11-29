# System requirements

## Hardware

### RAM

**4GB** required.
**8GB** or more recommended for a comfortable development experience. By default Docker Machine uses 1GB of RAM.

### CPU

Your CPU should support hardware **VT-x/AMD-V virtualization** (most modern CPUs) and it should be enabled in BIOS.

## Software

While Docker is supported natively on Linux, Mac and Windows users will need a VM layer to run Docker containers.

There are two main options to get Docker containers running on Mac or Windows:

1) Docker Machine + [VirtualBox](https://www.virtualbox.org) 5.0+ (mature, battle-tested)  
2) Docker for [Mac](https://docs.docker.com/docker-for-mac)/[Windows](https://docs.docker.com/docker-for-windows) (newer, experimental)

Please refer to the [setup instructions](env-setup.md#setup) for further steps.
