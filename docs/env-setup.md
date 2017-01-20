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

!!! danger "Install as a regular user"
    Babun should be installed and run **as a regular user** (do **NOT** run as Administrator to install).

Install [Babun](http://babun.github.io/) before proceeding and run all commands in it.
Docksal is not tested and not supported with other Linux-type shells on Windows.

### 2. Install VirtualBox

Install [VirtualBox 5.1.12 for Windows](http://download.virtualbox.org/virtualbox/5.1.12/VirtualBox-5.1.12-112440-Win.exe).

!!! attention "Specific version required"
    **Using the specified version is important.** If you use a different version, it may work fine or you may experience unexpected bugs. Fin will notify you to update your VirtualBox version in the future.

### 3. Install Docksal Fin

```bash
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

### 4. Install tools and configurations

```bash
fin update
```

### 5. Create and start the vm

```bash
fin vm start
```
[Help, my VM did not start!](troubleshooting.md#failed-creating-docksal-virtual-machine)

### 6. Congratulations!

You are done with the one time environment installation. Now you can [configure your project](project-setup.md) to use Docksal or create a new pre-configured Drupal or Wordpress project with `fin create-site`.

!!! info "Experimental support for Native Docker applications"
    Advanced Docker users may want to check out how to use Docksal with [Native Docker applications](env-setup-native.md).

<a name="macos"></a>
## Installing Docksal on macOS

### 1. Install VirtualBox

Install [VirtualBox 5.1.12 for Mac](http://download.virtualbox.org/virtualbox/5.1.12/VirtualBox-5.1.12-112440-OSX.dmg).

!!! attention "Specific version required"
    **Using the specified version is important.** If you use a different version, it may work fine or you may experience unexpected bugs. Fin will notify you to update your VirtualBox version in the future.

### 2. Install Docksal Fin

```bash
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

### 3. Install tools and configurations

```bash
fin update
```

### 4. Create and start the vm

```bash
fin vm start
```
[Help, my VM did not start!](troubleshooting.md#failed-creating-docksal-virtual-machine)

### 5. Congratulations!

You are done with the one time environment installation. Now you can [configure your project](project-setup.md) to use Docksal or create a new pre-configured Drupal or Wordpress project with `fin create-site`.

!!! info "Experimental support for Native Docker applications"
    Advanced Docker users may want to check out how to use Docksal with [Native Docker applications](env-setup-native.md).

<a name="linux"></a>
## Installing Docksal on Ubuntu Linux

### 1. Avoid conflict with Apache

By default Apache listens on `0.0.0.0:80` and `0.0.0.0:443`. This will prevent Docksal from running properly.

You either need to stop Apache or reconfigure it to listen on different ports (e.g. `8080` and `4433`) or different host (e.g. `127.0.0.1:80` and `127.0.0.1:443`).

### 2. Install Docksal Fin

```bash
sudo curl -L https://raw.githubusercontent.com/docksal/docksal/develop/bin/fin -o /usr/local/bin/fin && \
sudo chmod +x /usr/local/bin/fin
```

### 3. Install tools and configurations

```bash
fin update
```

### 4. Congratulations!

You are done with the one time environment installation. Now you can [configure your project](project-setup.md) to use Docksal or create a new pre-configured Drupal or Wordpress project with `fin create-site`.
