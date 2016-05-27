# System requirements

## Hardware

### RAM

**8GB** (16GB if you keep lost of apps running) for a comfortable work experience.  

It is possible to use Drude with less than 8GB of RAM (e.g. 4GB), however not recommended.  

The amount of RAM Drude reserves is configurable via the `vagrant.yml` file (2GB by default).  
You can lower it to 1GB if your host computer runs low on memory.  
Please understand that this will be the amount of RAM available to the application stack and sites running on it.

### CPU

Your CPU should support hardware **VT-x/AMD-V virtualization** (most modern CPUs) and it should be enabled in BIOS.

## Software

While Docker is supported natively on Linux, Mac and Windows users will need a tiny Linux VM layer to be able to run Docker containers.

Drude relies on the following components for Docker support on Mac and Windows:

- [VirtualBox](https://www.virtualbox.org) 5.0+
- [Vagrant](https://www.vagrantup.com) 1.7.3+
- [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant) v1.3.1+

**You do not have to install these components manually as Drude automates this for you.**  
Please refer to the [setup instructions](/README.md#setup) for further steps.