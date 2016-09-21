# Docksal

Docker and Docker Compose based environment.

**For a fully working example of Docksal setup take a look at:**
- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)


## System requirements

Please review [system requirements](/docs/system-requirements.md) before proceeding with the setup.


<a name="setup"></a>
## Setup

1. [Docksal environment setup](/docs/env-setup.md)
    
    This is done **one time per host** and should be performed by everyone.

2. [Configure a project to use Docksal](/docs/project-setup.md)

    This is done **one time per project** and should be performed by the project TL.


<a name="updates"></a>
## Updates

### Regular updates

```
fin update fin
fin update prerequisites
```

### Updating from Drude to Docksal 2.x

Drude used to rely on Vagrant and vagrant-boot2docker for running Docker.  
Docksal uses Docker Machine, which is more native and can be easily updated.
Vagrant machine is not going to be used anymore and should be deleted. 

1. Create dumps of databases you need using `drush`
2. Go to your `<projects>` folder and use `vagrant destroy` to destroy the old (Drude) VM. If you happened to have several of them, please destroy all.
3. You can uninstall vagrant if you do't need it (manually or `brew uninstall vagrant` on Mac, `choco uninstall vagrant` on Win)
4. Install fin
5. `fin install prerequisites`
6. Start your project just like you did before with `fin up` and re-import your DB dump. Notice it will use Docker Machine now. New Docker Machine will be created upon first start.
7. Run `fin cleanup` to delete old unused files and backups

<a name="fin"></a>
## Docksal Fin (fin)

Docksal Fin is a console tool that simplifies day-to-day work with Docksal.
It provides a set of most commonly used commands and operations for controlling the Boot2docker VM, containers, running drush or other commands inside the **cli** container. (**Note**: fin requires cli container to function properly)

See `fin help` for a complete list.

`fin` detects the environment it's launched in and will automatically start the boot2docker VM and launch containers as necessary.
It runs on Mac/Linux directly. On Windows `fin` runs inside the Babun Shell.


<a name="cli"></a>
## Console tools (cli container)

The **cli** container is meant to serve as a single console to access all necessary command line tools.
You can access **cli** container's console with `fin`:

```
fin bash
```

Tools available inside the **cli** container:

- php-cli, composer, drush[6,7,8], drupal console, phpcs, phpcbf
- ruby, bundler
- node, nvm, npm
- imagemagick
- python, git, mc, mysql-client and [more](https://github.com/blinkreaction/docker-drupal-cli)


<a name="instructions"></a>
## Instructions and tutorials

### Advanced configuration
- [Drupal settings](/docs/drupal-settings.md)
- [Overriding default PHP/MySQL/etc. settings](/docs/settings.md)
- [Running multiple projects](/docs/multiple-projects.md)
- [DB sandbox mode](/docs/db-sandbox.md)
- [MySQL DB access for external tools](/docs/db-access.md)
- [Extending fin with custom commands](/docs/custom-commands.md)

### Third party utililies
- [Debugging with Xdebug and PhpStorm](/docs/xdebug.md)
- [Using PHP Code Sniffer (phpcs, phpcbf)](/docs/phpcs.md)
- [Using Blackfire profiler](/docs/blackfire.md)
- [Public access via ngrok](/docs/public-access.md)
- [Using Behat](/docs/behat.md)
- [Sending and capturing e-mail](/docs/mail.md)
- [Enabling Varnish support](/docs/varnish.md)
- [Enabling Apache Solr support](/docs/apache-solr.md)
- [Using Sass](/docs/sass.md)

<a name="troubleshooting"></a>
## Troubleshooting

[Troubleshooting](https://github.com/docksal/docksal/issues)


## License

The MIT License (MIT)

Copyright © 2016 Blink Reaction

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
