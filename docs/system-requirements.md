# System requirements

## Software

While Docker is supported natively on Linux, Mac and Windows users will need a tiny Linux VM layer to be able to run Docker containers.

Drude relies on the following components for Docker support on Mac and Windows:

- [VirtualBox](https://www.virtualbox.org)
- [Vagrant](https://www.vagrantup.com)
- [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant)

Please refer to the installation and setup instruction for further steps.

## Hardware

### RAM

Boot2docker Vagrant Box requires 2GB of RAM by default.  
You will need a bare minimum of 4GB RAM on your computer to be able to use it.  
8GB of RAM is OK and 16GB is recommended for comfortable work with lots of tabs and windws open.

The amount of RAM Boot2docker Vagrant Box reserves is configurable.  
You can lower it to 1GB if your host computer runs low on memory.  
Please understand that this will be the amount of RAM available to the entire Docker powered stack and your sites.

### CPU

Your CPU should support hardware VT-x/AMD-V virtualization (most modern CPUs)
