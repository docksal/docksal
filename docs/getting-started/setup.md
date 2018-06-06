# Setup instructions

<a name="install"></a>
## Installation

1. [System requirements](../getting-started/system-requirements.md)
2. [Initial Docksal environment setup](../getting-started/env-setup.md)
3. [Configuring a project to use Docksal](../getting-started/project-setup.md)

!!! tip "Coming from Drude (DDE)?"
    You will find a lot of similarities and a lot more new features that Docksal has over Drude (DDE).  
    Follow [Updating from Drude (DDE) to Docksal](../getting-started/update-dde.md) instructions. 


<a name="examples"></a>
## Example projects

With Docksal starting a complete LAMP stack for Drupal, WordPress or a pure HTML/PHP based website can be two commands away!

```bash
git clone <sample-project-repo>
fin init
```

Try one of the example projects:

### PHP Based
- [Drupal 8 sample project](https://github.com/docksal/drupal8)  
- [Drupal 7 sample project](https://github.com/docksal/drupal7)  
- [Backdrop CMS](https://github.com/docksal/example-backdrop)
- [WordPress sample project](https://github.com/docksal/wordpress)
- [Symfony Skeleton](https://github.com/docksal/example-symfony-skeleton)
- [Symfony WebApp](https://github.com/docksal/example-symfony-webapp)
- [Magento sample project](https://github.com/docksal/magento)
- [Laravel sample project](https://github.com/docksal/example-laravel)
- [GRAV CMS](https://github.com/docksal/example-grav)

### JS Based
- [NodeJS sample project](https://github.com/docksal/example-nodejs)
- [Gatsby](https://github.com/docksal/example-gatsby)
- [Hugo sample project](https://github.com/docksal/example-hugo)

You can also use the `fin project create` command and a wizard will take you through the steps.

<a name="updates"></a>
## Updates

All Docksal components can be updated with a single command:

```bash
fin update
```


<a name="uninstall"></a>
## Uninstallation

The steps below will remove the Docksal VM and cleanup all Docksal stuff.

```bash
fin vm remove
rm -rf "$HOME/.docksal"
rm -f /usr/local/bin/fin
```

Docker for Mac/Windows and VirtualBox are not automatically removed. You can remove them manually on Mac or use the uninstaller on Windows.

To remove Docker on Ubuntu Linux:

1. Follow [Docker Uninstallation](https://docs.docker.com/engine/installation/linux/ubuntulinux/#/uninstallation) instructions
2. Remove the Docker tools:

```bash
sudo rm /usr/local/bin/docker-compose
sudo rm /usr/local/bin/docker-machine
```


<a name="troubleshoting"></a>
## Troubleshooting

!!! attention "If something is wrong" 
    Quite often a problem may reside within the 3rd party tools, project code, local configuration, etc., and not the stack.  
    To make sure that the Docksal stack works properly, try launching any of the [sample projects](#examples).  
    If you believe the issue is with the stack, then read on.

First, try these quick fix steps in the order listed below. Check if the issue has cleared out **after each step**.

- Update Docksal to the latest version. See the [updates](#updates) section.
- (Mac and Windows) Restart the Docksal VM: `fin vm restart`
- Reset Docksal system services with `fin system reset` and restart project containers with `fin project restart`
- Reboot the host (your computer or remote server)
- (Mac and Windows) Re-create Docksal VM: `fin vm remove` then `fin vm start` (**WARNING**: backup your DB data before doing this)

If the quick fixes above did not help, try:

- checking the [troubleshooting doc](../troubleshooting.md) for rare problems that might occur
- searching the [GitHub issue queue](https://github.com/docksal/docksal/issues). Others may have experienced a similar issue and already found a solution or a workaround.
- asking community for support in our [Gitter room](https://gitter.im/docksal/community-support)

Create a [new issue](https://github.com/docksal/docksal/issues/new) if your problem is still not resolved.
