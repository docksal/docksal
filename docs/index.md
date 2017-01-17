# Docksal

Docker and Docker Compose based environments for web development.

!!! attention "Docksal is under active development" 
    Breaking changes and outdated docs are very possible. Please help us by testing, submitting issues and pull requests. Thanks!

Running a complete LAMP stack for Drupal, WordPress or a pure HTML/PHP based website is two commands away!<sup>*</sup>

```
git clone <sample-project-repo>
fin init
```

Try one of the preconfigured projects:

- [Drupal 7 sample project](https://github.com/docksal/drupal7)  
- [Drupal 8 sample project](https://github.com/docksal/drupal8)  
- [WordPress sample project](https://github.com/docksal/wordpress)

<sup>*</sup>Once you are done with a one-time [Docksal environment setup](env-setup.md)

<a name="setup"></a>
## Docksal Setup

Please review [system requirements](system-requirements.md) before proceeding with the setup.

**1. [Install required software](env-setup.md)**

**2. [Create a Docksal powered project](project-setup.md)**

<a name="fin"></a>
## Docksal Fin and stack

Docksal Fin is a command line tool for controlling Docksal's stack. `fin` runs natively on Mac and Linux but requires [Babun Shell](http://babun.github.io) on Windows.

Each project contains at least 3 services:

- `web` - holds your webserver (nginx/apache/etc.)
- `db` - holds your database server (MySQL)
- `cli` - serves as a single access point for all necessary command line tools. You can access it with `fin bash`. For the list of tools available inside `cli` check [CLI image docs](https://github.com/docksal/service-cli).

<a name="updates"></a>
## Updating Docksal

```
fin update
```

<a name="instructions"></a>
## Additional Instructions

### Advanced configuration
- [Running multiple projects](multiple-projects.md)
- [Drupal settings](drupal-settings.md)
- [MySQL DB access for external tools](db-access.md)
- [Overriding default PHP/MySQL/etc. settings](settings.md)
- [Drush aliases](drush-aliases.md)
- [Automatic database import](db-import.md)
- [Extending fin with custom commands](custom-commands.md)
- [Increasing vm memory (RAM)](vm.md)
- [Exposing any Docker container's port](expose-port.md)
- [Customize project configuration or switch PHP/MySQL version](project-customize.md)

### Utililies
- [Debugging with Xdebug and PhpStorm](xdebug.md)
- [Using custom ssh keys (with or without passwords) via ssh-agent](ssh-agent.md)
- [Sending and capturing e-mail](mail.md)
- [SASS/Compass](sass.md)
- [PHP Code Sniffer (phpcs, phpcbf)](phpcs.md)
- [Varnish](varnish.md)
- [Memcached](memcached.md)
- [Apache Solr](apache-solr.md)
- [Blackfire profiler](blackfire.md)
- [Behat](behat.md)
- [Public access via ngrok](public-access.md)

<a name="troubleshooting"></a>
## Troubleshooting

!!! attention "If something went wrong" 
    First try these quick fix steps in the order listed below. Check if the issue has cleared out **after each step**.

- Update Docksal to the latest version. See [updates](#updates) section.
- (Mac and Windows) Restart the Docksal VM: `fin vm restart`
- Reset Docksal system services with `fin reset system` and restart project containers with `fin up`
- Reboot the host (your computer or remote server)
- (Mac and Windows) Re-create Docksal VM: `fin vm remove` then `fin vm start` (**WARNING**: backup your DB data before doing this)

If quick fixes above did not help, try:

- checking the [troubleshooting doc](troubleshooting.md) for rare problems that might occur
- searching the [GitHub issue queue](https://github.com/docksal/docksal/issues). Others may have experienced a similar issue and already found a solution or a workaround.
- asking community for support in our [Gitter room](https://gitter.im/docksal/community-support)

Create a [new issue](https://github.com/docksal/docksal/issues/new) if your problem is still not resolved.

## Uninstallation

The steps below will remove the Docksal VM and cleanup Docksal stuff.

```
fin vm remove
rm -rf ~/.docksal
rm -f /usr/local/bin/fin
```

Docker for Mac/Windows and VirtualBox are not automatically removed. You can remove them manually on Mac or use the uninstaller on Windows.

To remove Docker on Ubuntu Linux you need to:

1. Follow [Docker Uninstallation](https://docs.docker.com/engine/installation/linux/ubuntulinux/#/uninstallation) instructions
2. Remove the Docker tools:
```
sudo rm /usr/local/bin/docker-compose
sudo rm /usr/local/bin/docker-machine
```
