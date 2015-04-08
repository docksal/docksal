# Drude (**Dru**pal **D**ocker **E**nvironment)
Docker and Docker Compose based environment for Drupal.

[![Circle CI](https://circleci.com/gh/blinkreaction/drude.svg?style=shield)](https://circleci.com/gh/blinkreaction/drude)

<a name="requirements"></a>
## Requirements

Docker is natively supported only on Linux.  
Mac and Windows users will need a tiny linux VM layer - [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant)

### Mac and Windows

1. Get the [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant) up and running.
2. Install [dsh](#dsh) tool (Drude Shell) wrapper

    ```
    curl -s https://raw.githubusercontent.com/blinkreaction/drude/master/install-dsh.sh | bash
    ```

### Linux
1. [Docker](https://docs.docker.com/compose/install/#install-docker)
2. [Docker Compose](https://docs.docker.com/compose/install/#install-compose)
3. Install [dsh](#dsh) tool (Drude Shell) wrapper

    ```
    curl -s https://raw.githubusercontent.com/blinkreaction/drude/master/install-dsh.sh | bash
    ```

<a name="setup"></a>
## Setup

Drude initial setup is done once per project (e.g. by a team lead).  
Once installed into the project repo, Drude can be used by anyone on the team.  
To use Drude each team member will need to meet the [requirements](#requirements) outlined above.

`docker-compose.yml` file and `.docker` folder are good indicators of Drude's presence in the project repo.

**If this is the first time Drude is being installed into the project, follow the instructions below.**  

The installation process is slightly different based on the OS.

### Mac

 1. Make sure your site's docroot is in `</path/to/project>/docroot`.
 2. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 3. cd `</path/to/project>` and run:

    ```
    curl -s https://raw.githubusercontent.com/blinkreaction/drude/master/install-drude.sh | bash
    ```
    
 4. Start containers with `dsh up`

### Windows

 1. Make sure your site's docroot is in `</path/to/project>/docroot`.
 2. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 3. Open Git Bash shell and cd into `</path/to/project>`, then run:

    ```
    curl -s https://raw.githubusercontent.com/blinkreaction/drude/master/install-drude.sh | bash
    ```
    
 4. Start and login into vagrant, cd into `</path/to/project>`:
 
    ```
    vagrant up
    vagrant ssh
    cd </path/to/project>
    ```

 5. Start containers with `dsh up`

### Linux

 1. Make sure your site's docroot is in `</path/to/project>/docroot`.
 2. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 3. cd `</path/to/project>` and run:

    ```
    curl -s https://raw.githubusercontent.com/blinkreaction/drude/master/install-drude.sh | bash
    ```

 4. Start containers with `dsh up`

<a name="updates"></a>
## Updates

To update Drude run the following from the `</path/to/project>` folder:

    curl -s https://raw.githubusercontent.com/blinkreaction/drude/master/install-drude.sh | bash

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
- [DB connection settings](.docker/docs/drupal-settings.md#db)
- [File permissions fix](.docker/docs/drupal-settings.md#file-permissions)

**Optional**
- [Memcache settings](.docker/docs/drupal-settings.md#memcache)

<a name="dsh"></a>
## Drude Shell (dsh)

Drude shell (dsh) is a console tool that simplifies that day-to-day work with Drude.
It provide a set of most commonly used commands and operations for controlling the Boot2docker VM, containers, running drush and other console commands inside the **cli** container.

See `dsh help` for a complete list.

`dsh` detects the environment it's launched in and will automatically start the boot2docker VM and launch containers as necessary.
It runs on Mac/Linux directly. On Windows `dsh` runs inside the boot2docker VM.

### Installation

    curl -s https://raw.githubusercontent.com/blinkreaction/drude/master/install-dsh.sh | bash

This will install a local dsh wrapper into `/usr/local/bin/dsh`.
The actual dsh script resides in each project individually (in `.docker/bin/dsh`) and is installed into the project along with Drude. The wrapper makes it possible to use `dsh` from anywhere in the project tree.

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
- [Using Behat](.docker/docs/behat.md)

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
