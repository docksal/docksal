# Docksal environment setup

**This is a one time setup.**  
Once you have a working Docksal environment in place, you can use it for all Docksal powered projects.

## Directory structure

All your Docksal projects should be located **under current user's home folder**.
Docksal recommends a particular [directory structure](/docs/directory-structure.md).  

## Windows only

On Windows you will need a Linux-type shell.

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.  
Instructions were not tested with other shells on Windows.

Babun should be installed and run **as a regular user (do not use admin command prompt).**

## Setup

1. Install [VirtualBox](https://www.virtualbox.org)
2. Install `fin` (Docksal Shell Helper)

    ```
    sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin
    sudo chmod +x /usr/local/bin/fin
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

4. Install Docksal's prerequisites

    ```
    fin install prerequisites
    ```
