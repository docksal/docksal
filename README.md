# Docksal [![Latest Release](https://img.shields.io/github/release/docksal/docksal.svg?style=flat-square)](https://github.com/docksal/docksal/releases/latest)

[![Build Status](https://img.shields.io/travis/docksal/docksal.svg?style=flat-square)](https://travis-ci.org/docksal/docksal)
[![Docs](https://readthedocs.org/projects/docksal/badge?version=master&style=flat-square)](http://docksal.readthedocs.io/en/master)
[![Gitter](https://img.shields.io/gitter/room/docksal/community-support.svg?style=flat-square)](https://gitter.im/docksal/community-support)

Docker powered environments for web development.  

Running a complete LAMP stack for your project can be two steps away!<sup>*</sup>

```
git clone <sample-project-repo>
fin init
```

Try one of the pre-configured sample projects:

- [Drupal 8 sample project](https://github.com/docksal/drupal8)
- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [WordPress sample project](https://github.com/docksal/wordpress)
- [Magento sample project](https://github.com/docksal/magento)

<sup>*</sup>Once you are done with a one-time [Docksal environment setup](/docs/env-setup.md)


## Better than VMs

"I love my Vagrant box. Why would I want to switch to a Docker based solution?"  
Containers are just [better than VMs](https://github.com/docker/docker#better-than-vms): 
smaller, faster, portable and more efficient across the board.


<a name="setup"></a>
<a name="updates"></a>
## Getting started

Docksal works with Linux, Mac and Windows.  
Follow the [Setup](/docs/setup.md) documentation for instructions on getting started. 

Updating from a pre-release (v0.x.y)?  
You can safely ignore the backward compatibility warning from `fin` and proceed with the update.

<a name="instructions"></a>
## Tutorials

Once you get the basics straight, feel free to explore the more advanced use cases. 

### Advanced configuration
- [Running multiple projects](/docs/multiple-projects.md)
- [Drupal settings (database, file permissions)](/docs/drupal-settings.md)
- [MySQL DB access for external tools](/docs/db-access.md)
- [Overriding default PHP/MySQL/etc. settings](/docs/settings.md)
- [Drush aliases](/docs/drush-aliases.md)
- [Automatic database import](docs/db-import.md)
- [Database sandbox mode](/docs/db-sandbox.md)
- [Extending fin with custom commands](/docs/custom-commands.md)
- [Increasing vm memory (RAM)](/docs/vm.md)
- [Exposing any Docker container's port](/docs/expose-port.md)
- [Using Docker for Mac/Win](/docs/env-setup-native.md)
- [Customize project configuration or switch PHP/MySQL version](/docs/project-customize.md)

### Utililies
- [Debugging with Xdebug and PhpStorm](/docs/xdebug.md)
- [Using custom ssh keys (with or without passwords) via ssh-agent](/docs/ssh-agent.md)
- [Sending and capturing e-mail](/docs/mail.md)
- [SASS/Compass](/docs/sass.md)
- [PHP Code Sniffer (phpcs, phpcbf)](/docs/phpcs.md)
- [Varnish](/docs/varnish.md)
- [Memcached](/docs/memcached.md)
- [Apache Solr](/docs/apache-solr.md)
- [Blackfire profiler](/docs/blackfire.md)
- [Behat](/docs/behat.md)
- [Public access via ngrok](/docs/public-access.md)


## Contributing to Docksal

Ready to give back? Check the [Contributing](CONTRIBUTING.md) docs on how to get involved.  
We have a room on Gitter where questions can be asked and answered 
[![Gitter](https://img.shields.io/gitter/room/docksal/community-support.svg?style=flat-square)](https://gitter.im/docksal/community-support)  
If you have experience with Docksal and Docker, please stick around in the room to help others.


## Roadmap

Wondering what's coming up next? See [Docksal Roadmap](ROADMAP.md).

For the list of current and past releases check the [Release](https://github.com/docksal/docksal/releases) section.  
Change records are published there and in the [Changelog](CHANGELOG.md) docs. 
