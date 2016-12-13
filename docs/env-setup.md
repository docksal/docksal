# Docksal environment setup

!!! important "This is a one time setup"
    Once you have a working Docksal environment in place, you can use it for all Docksal powered projects.

## (Win) Install Babun

On Windows you will need a Linux-type shell.

!!! danger "Install as regular user"
    Babun should be installed and run **as a regular user (do NOT use running installer as and admin).**

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.  
Docksal is not tested and not supported with other Linux-type shells on Windows.

## (Mac/Win) Install VirtualBox

On Mac and Windows you need to install [VirtualBox 5.1.2 Mac](http://download.virtualbox.org/virtualbox/5.1.2/VirtualBox-5.1.2-108956-OSX.dmg)/[VirtualBox 5.1.2 Win](http://download.virtualbox.org/virtualbox/5.1.2/VirtualBox-5.1.2-108956-Win.exe)

!!! attention "Specific version required"
    **Using specific version is important.** If you use different version it can work fine or you can experience unexpected bugs. fin will notify you about a need to update your VirtualBox version in future.

## (Mac/Win/Linux) Install Docksal Fin

```bash
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

## (Mac/Win/Linux) Install tools and configurations

```bash
fin update
```

## (Mac/Win) Create and start vm

```bash
fin vm start
```

[Help, my VM did not start!](/docs/troubleshooting.md#failed-creating-docksal-virtual-machine)

## Congratulations!

You are done with one time environment installation. Now you can [configure your project](/docs/project-setup.md) to use Docksal or create a new pre-configured Drupal or Wordpress project with `fin create-site`.

!!! tip "Native Docker application on Mac and Windows"
    Advanced Docker users may want to check out how to use Docksal with [Native Docker applications on Mac and Windows](env-setup-native.md).

