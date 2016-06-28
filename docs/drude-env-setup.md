# Drude environment setup

**This is a one time setup.**  
Once you have a working Drude environment in place, you can use it for all Drude powered projects.

## Directory structure

All your Drude projects should be located **under current user's home folder**.
Drude recommends a particular [directory structure](/docs/directory-structure.md).  

## Windows only

On Windows you will need a Linux-type shell.

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.  
Instructions were not tested with other shells on Windows.

Babun should be installed and run **as a regular user (do not use admin command prompt).**

## Setup

1. Install [VirtualBox](https://www.virtualbox.org)
2. Install `dsh` (Drude Shell Helper)

    ```
    sudo curl -L https://raw.githubusercontent.com/blinkreaction/drude/master/bin/dsh -o /usr/local/bin/dsh
    sudo chmod +x /usr/local/bin/dsh
    ```

3. Create the `<projects>` directory

    E.g. `~/WebProjects` on Mac and Linux:
    
    ```
    mkdir ~/WebProjects
    cd ~/WebProjects
    ```

    `c:\Users\CurrentUser\WebProjects` (`/c/Users/CurrentUser/WebProjects`) on Windows:

    ```
    mkdir /c/Users/CurrentUser/WebProjects
    cd /c/Users/CurrentUser/WebProjects
    ```

4. Install Drude's prerequisites

    ```
    dsh install prerequisites
    ```
