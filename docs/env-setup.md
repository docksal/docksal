# Docksal environment setup

!!! tip "This is a one time setup"
    Once you have a working Docksal environment in place, you can use it for all Docksal powered projects.

Installing Docksal on
- [Windows](#windows)
- [macOS](#macos)
- [Ubuntu Linux](#linux)

<a name="windows"></a>
## Installing Docksal on Windows

### 1. Install Babun

On Windows, you will need a Linux-type shell.

!!! danger "Install as regular user"
    Babun should be installed and run **as a regular user (do NOT Run as Administrator to install).**

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.
Docksal is not tested and not supported with other Linux-type shells on Windows.

### 2. Install VirtualBox

You need to install [VirtualBox 5.1.2 Win](http://download.virtualbox.org/virtualbox/5.1.2/VirtualBox-5.1.2-108956-Win.exe).

!!! attention "Specific version required"
    **Using specific version is important.** If you use a different version, it could work fine or you may experience unexpected bugs. fin will notify you to update your VirtualBox version in the future.

### 3. Install Docksal Fin

```bash
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

### 4. Install tools and configurations

```bash
fin update
```

### 5. Create and start vm

```bash
fin vm start
```
[Help, my VM did not start!](/docs/troubleshooting.md#failed-creating-docksal-virtual-machine)

### 6. Congratulations!

You are done with the one time environment installation. Now you can [configure your project](/docs/project-setup.md) to use Docksal or create a new pre-configured Drupal or Wordpress project with `fin create-site`.

!!! info "Experimental support for Native Docker application"
    Advanced Docker users may want to check out how to use Docksal with [Native Docker application](env-setup-native.md).

<a name="macos"></a>
## Installing Docksal on macOS

### 1. Install VirtualBox

You need to install [VirtualBox 5.1.2 Mac](http://download.virtualbox.org/virtualbox/5.1.2/VirtualBox-5.1.2-108956-OSX.dmg).

!!! attention "Specific version required"
    **Using specific version is important.** If you use a different version, it could work fine or you may experience unexpected bugs. fin will notify you to update your VirtualBox version in the future.

### 2. Install Docksal Fin

```bash
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

### 3. Install tools and configurations

```bash
fin update
```

### 4. Create and start vm

```bash
fin vm start
```
[Help, my VM did not start!](/docs/troubleshooting.md#failed-creating-docksal-virtual-machine)

### 5. Congratulations!

You are done with the one time environment installation. Now you can [configure your project](/docs/project-setup.md) to use Docksal or create a new pre-configured Drupal or Wordpress project with `fin create-site`.

!!! info "Experimental support for Native Docker application"
    Advanced Docker users may want to check out how to use Docksal with [Native Docker application](env-setup-native.md).

<a name="linux"></a>
## Installing Docksal on Ubuntu Linux

### 1. Install Docksal Fin

```bash
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

### 2. Install tools and configurations

```bash
fin update
```

### 3. Congratulations!

You are done with the one time environment installation. Now you can [configure your project](/docs/project-setup.md) to use Docksal or create a new pre-configured Drupal or Wordpress project with `fin create-site`.
