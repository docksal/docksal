# Docksal environment setup

**This is a one time setup.**  
Once you have a working Docksal environment in place, you can use it for all Docksal powered projects.

## Windows only

On Windows you will need a Linux-type shell.

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.  
Instructions were not tested with other shells on Windows.

Babun should be installed and run **as a regular user (do not use admin command prompt).**

## Setup

1. Install [VirtualBox](https://www.virtualbox.org) (**Mac and Windows only**)
2. Install `fin` (Docksal control utility)

    ```
    sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin
    sudo chmod +x /usr/local/bin/fin
    ```

3. Install Docksal prerequisites

    ```
    fin install prerequisites
    ```
