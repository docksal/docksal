# Drude (**Dru**pal **D**ocker **E**nvironment)
Docker and Docker Compose based environment for Drupal.

[![Circle CI](https://circleci.com/gh/blinkreaction/drude.svg?style=shield)](https://circleci.com/gh/blinkreaction/drude)

<a name="requirements"></a>
## Requirements

### Mac and Windows
Docker is not supported natively on Mac and requires a Boot2docker VM - [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant)

On **Mac**, install [Docker](https://docs.docker.com/compose/install/#install-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose) natively. This can be done via brew:

    brew install docker docker-compose
    docker version
    docker-compose --version

On **Windows**, both tools can be used inside the Boot2docker VM. In fact, this is the only option available for Windows right now.

### Linux
1. [Docker](https://docs.docker.com/compose/install/#install-docker)
2. [Docker Compose](https://docs.docker.com/compose/install/#install-compose)

<a name="setup"></a>
## Setup and usage

The installation process is slightly different based on the OS.

### Mac

 1. Make sure your site's docroot is in `</path/to/project>/docroot`.
 2. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 3. cd `</path/to/project>` and run:

    ```
    curl https://raw.githubusercontent.com/blinkreaction/drude/master/install.sh | bash
    dsh up
    ```

### Windows

 1. Make sure your site's docroot is in `</path/to/project>/docroot`.
 2. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 3. Copy `.docker` and `docker-compose.yml` from this repo into `</path/to/project>`.
 4. Open GitBash shell and cd into `</path/to/project>`, then run:

    ```
    vagrant up
    vagrant ssh
    dsh up
    ```

### Linux

 1. Make sure your site's docroot is in `</path/to/project>/docroot`.
 2. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 3. cd `</path/to/project>` and run:

    ```
    curl https://raw.githubusercontent.com/blinkreaction/drude/master/install.sh | bash
    docker-compose up -d
    ```

<a name="updates"></a>
## Updates

To update Drude run the following from the `</path/to/project>` folder:

    curl https://raw.githubusercontent.com/blinkreaction/drude/master/install.sh | bash

Review the changes, revert any local overrides that were reset and commit into your project git repo.

Base images will be updated from time to time. Docker Compose does not automatically pull new image versions.
To get an up-to-date version of the entire stack do:

    docker-compose pull
    docker-compose up -d

<a name="drupal-settings"></a>
## Drupal settings

Below you will find instructions on configuring you Drupal project to work with Drude.
Some settings are required, others are optional or enahncements. Please review carefully.

**Required**
- [DB connection settings](.docker/docs/drupal-settings#db)
- [File permissions fix](.docker/docs/drupal-settings#file-permissions)

**Optional**
- [Memcache settings](.docker/docs/drupal-settings#memcache)

<a name="dsh"></a>
## Drude Shell (dsh)

Drude shell (dsh) is a console tool that simplifies that day-to-day work with Drude.
It provide a set of most commonly used commands and operations for controlling the Boot2docker VM, containers, running drush and other console commands inside the **cli** container.

See `dsh help` for a complete list:

    Usage: dsh <command> [params]
    Commands list:

      start (up)    Start vagrant vm (mac only) and docker containers -OR- restarts docker containers
      stop (down, halt) Stop vagrant vm (mac only) or stop containers
      reload (restart)  Re-start vagrant vm (mac only) and docker containers
      status (st, ps)   Show vm/containers status
      bash      Start bash on cli container
      exec (run)    Execute a command in cli container (usage: dsh exec <command> [param] [param] [param]...)
      mysql     Opens mysql shell to drude database
      mysql-import    Truncate database and import from sql dump (usage: dsh mysql-import <filename>)
              Note: <filename> should be inside your project root
      drush     Shorthand for executing drush commands (usage: dsh drush [command] [options])
      cc      Shorthand for clearing caches (usage: dsh cc [cache_type] ("dsh cc" is equal to "dsh cc all")
      help      Output this help
      ...

`dsh` is automatically installed when you install Drude via the [install.sh](https://raw.githubusercontent.com/blinkreaction/drude/master/install.sh) script

    curl https://raw.githubusercontent.com/blinkreaction/drude/master/install.sh | bash

`dsh` detects the environment it's launched in and will automatically start the boot2docker VM and launch containers as necessary.
It runs on Mac/Linux directly. On Windows `dsh` runs inside the boot2docker VM.

<a name="cli"></a>
## Console tools (cli)

**cli** container is ment to serv as a single console to access all necessary command line tools.
The **cli** console can launch with `dsh`:

    dsh bash

Tools available inside the **cli** container:

- php-cli, composer, drush7
- ruby, bundler
- node, npm, bower, grunt
- git, wget, zip, mysql-client
- python

<a name="instructions"></a>
## Instructions and tutorials

- [Running multiple projects](.docker/docs/multiple-projects.md)
- [Overriding default PHP/MySQL/etc. settings](.docker/docs/settings.md)
- [Public access](.docker/docs/public-access.md)
- [DB sandbox mode](.docker/docs/db-sandbox.md)

## License

The MIT License (MIT)

Copyright (c) 2015 BlinkReaction

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
