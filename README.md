# Docksal [![Latest Release](https://img.shields.io/github/release/docksal/docksal.svg?style=flat-square)](https://github.com/docksal/docksal/releases/latest)

[![Build Status](https://img.shields.io/travis/docksal/docksal.svg?style=flat-square)](https://travis-ci.org/docksal/docksal)
[![Docs](https://readthedocs.org/projects/docksal/badge?version=master&style=flat-square)](http://docksal.readthedocs.io/en/master)
[![Gitter](https://img.shields.io/gitter/room/docksal/community-support.svg?style=flat-square)](https://gitter.im/docksal/community-support)

Docker and Docker Compose based environments for web development.

    Docksal is still under active development. Breaking changes and outdated docs are very possible.
    Please help us by testing, submitting issues and PRs. Thanks!


## Examples of preconfigured Docksal powered projects

Running a complete LAMP stack for Drupal, WordPress or a pure HTML/PHP base website is two commands away!<sup>*</sup>

```
git clone <sample-project-repo>
fin init
```

Try one of the preconfigured projects:

- [Drupal 7 sample project](https://github.com/docksal/drupal7)  
- [Drupal 8 sample project](https://github.com/docksal/drupal8)  
- [WordPress sample project](https://github.com/docksal/wordpress)

<sup>*</sup>Once you are done with a one-time [Docksal environment setup](/docs/env-setup.md)


<a name="setup"></a>
## Setup

Please review [system requirements](/docs/system-requirements.md) before proceeding with the setup.

1. [Docksal environment setup](/docs/env-setup.md)
    
    This is done **one time per host** and should be performed by everyone.

2. [Configure a project to use Docksal](/docs/project-setup.md)

    This is done **one time per project** and should be performed by the project TL.

<a name="fin"></a>
## Docksal Fin (fin)

Docksal Fin is a command line tool to control Docksal's stack. `fin` runs natively on Mac and Linux and requires [Babun Shell](http://babun.github.io) on Windows.

## Docksal Stack

Each project contains at least 3 services:
* `web` - holds your webserver (nginx/apache/etc.)
* `db` - holds database server (MySQL)
* `cli` - container that is meant to serve as a single console access point to all necessary command line tools. You can access it with `fin bash`. For the list of tools available inside **cli** check [CLI image docs](https://github.com/docksal/service-cli)

<a name="updates"></a>
## Updates

### Regular updates

```
fin update
```

If updating from versions below `v0.7.0`

```
fin update self && fin update
```

### Updating from Drude to Docksal

Drude used to rely on Vagrant and vagrant-boot2docker for running Docker.  
Docksal uses Docker Machine, which is more native and supports seamless (non-destructive) Docker version updates.  
Vagrant machine is not going to be used anymore and should be deleted.

1. Create dumps of databases you need with `drush`
2. `vagrant destroy` the old Drude VM

    Go to your Drude projects folder (the one with `Vagrantfile` and `vagrant.yml`) and use `vagrant destroy` to destroy the Drude VM. 
    If you happened to have several of them, please destroy all.
    
    It is very important to use `vagrant destroy` and not delete the VM manually in VirtualBox.  
    Vagrant has to clean things up properly and that is what `vagrant destroy` is for.     

3. Uninstall vagrant if you do not plan to use it for other purposes

    Depending on how Vagrant was installed you will either have to uninstall it manually or
    via `brew uninstall vagrant` on Mac / `choco uninstall vagrant` on Windows
    
4. Follow instructions in [Docksal environment setup](/docs/env-setup.md)
5. Start your project just like you did before with `fin up` and re-import your DB dump.

    Notice it will use Docker Machine now.
    New Docker Machine will be created upon first start.
    
6. Run `fin cleanup` to delete Drude files and backups


## Uninstallation

The steps below will remove the Docksal VM and cleanup Docksal stuff.

```
fin vm remove
rm -rf ~/.docksal
rm -f /usr/local/bin/fin
```

Docker for Mac/Windows and VirtualBox are not automatically removed. You can remove them manually on Mac or use uninstaller on Windows.

To remove Docker on Ubuntu Linux you need to:

1. Follow [Docker Uninstallation](https://docs.docker.com/engine/installation/linux/ubuntulinux/#/uninstallation) instruction
2. Cleanup tools:
```
sudo rm /usr/local/bin/docker-compose
sudo rm /usr/local/bin/docker-machine
```

<a name="instructions"></a>
## Instructions and tutorials

### Advanced configuration
- [Running multiple projects](/docs/multiple-projects.md)
- [Customize project configuration](/docs/project-customize.md)
- [Drupal settings](/docs/drupal-settings.md)
- [MySQL DB access for external tools](/docs/db-access.md)
- [Overriding default PHP/MySQL/etc. settings](/docs/settings.md)
- [Automatic database import](docs/db-import.md)
- [DB sandbox mode](/docs/db-sandbox.md)
- [Extending fin with custom commands](/docs/custom-commands.md)
- [Increasing vm memory (RAM)](/docs/vm.md)
- [Exposing any Docker container's port](/docs/expose-port.md)

### Third party utililies
- [Debugging with Xdebug and PhpStorm](/docs/xdebug.md)
- [Using custom ssh keys (with or without passwords) via ssh-agent](/docs/ssh-agent.md)
- [Sending and capturing e-mail](/docs/mail.md)
- [Using Sass](/docs/sass.md)
- [Using PHP Code Sniffer (phpcs, phpcbf)](/docs/phpcs.md)
- [Enabling Varnish support](/docs/varnish.md)
- [Enabling Apache Solr support](/docs/apache-solr.md)
- [Using Blackfire profiler](/docs/blackfire.md)
- [Using Behat](/docs/behat.md)
- [Public access via ngrok](/docs/public-access.md)

<a name="troubleshooting"></a>
## Troubleshooting

If something went wrong, first try these quick fix steps in the order listed below.
Check if the issue has cleared out **after each step**.

- Update Docksal to the latest version. See [updates](#updates) section.
- (Mac and Windows) Restart the Docksal VM: `fin vm restart`
- Reset Docksal system services with `fin reset system` and restart projects containers with `fin up`
- Reboot the host (your computer or remote server)
- (Mac and Windows) Re-create Docksal VM: `fin vm remove` then `fin vm start` (**WARNING**: backup your DB data before doing this)

If quick fixes above did not help, try:
- checking [troubleshooting doc](docs/troubleshooting.md) for rare problems that might occur
- searching the [GitHub issue queue](https://github.com/docksal/docksal/issues). Others may have experienced same or a similar issue and have already found a solution or a workaround.
- asking community for support in our Gitter room [![Gitter](https://img.shields.io/gitter/room/docksal/community-support.svg?style=flat-square)](https://gitter.im/docksal/community-support)

Create a new issue if your problem is still not resolved.
