# Drude environment setup

**This is a one time setup.**  
Once you have a working Drude environment in place, you can use it for all Drude powered projects.

## Directory structure

Drude expects a particular [directory structure](/docs/directory-structure.md).  
Please review it before proceeding with the setup.

## Windows only

On Windows you will need a Linux-type shell.

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.  
Instructions were not tested with other shells on Windows.

Babun should be installed and run **as a regular user (do not use admin command prompt).**

## Setup

1. Install `dsh` (Drude Shell)

    ```
    sudo curl -L https://raw.githubusercontent.com/blinkreaction/drude/master/bin/dsh  -o /usr/local/bin/dsh
    sudo chmod +x /usr/local/bin/dsh
    ```

2. Create the `<projects>` directory

    E.g. `~/projects` on Mac and Linux:
    
    ```
    mkdir ~/projects
    cd ~/projects
    ```

    `c:\projects` (`/c/projects`) on Windows:

    ```
    mkdir /c/projects
    cd /c/projects
    ```

3. Install Drude's prerequisites

    Mac and Windows: virtualbox, vagrant, boot2docker-vagrant  
    Linux: docker, docker-compose
    
    It is recommended to remove any previous versions of these before proceeding.
    
    ```
    dsh install prerequisites
    dsh install boot2docker
    ```
    
    On Mac and Windows you should see two files created in the `projects` folder:
    
    ```
    Vagrantfile
    vagrant.yml
    ```

    On Linux there's no need in Vagrant (and VirtualBox), so no additional files are created. 
