# Drude (**Dru**pal **D**ocker **E**nvironment)
Docker and Docker Compose based environment for Drupal.

[![Circle CI](https://circleci.com/gh/blinkreaction/drude.svg?style=shield)](https://circleci.com/gh/blinkreaction/drude)

To get Drude follow the instructions below.

## Install dsh (Drude Shell Helper)

### Windows 

 1. [Install Babun](http://babun.github.io)

**On Windows you will need Linux-type shell. All further Drude interactions are supposed to be done in Babun shell on Windows and require pact package manager. Instructions were not tested with other CYGWIN shells.**

### Mac, Windows (Babun shell), Linux
To install [dsh](#dsh) run:

    sudo curl -L https://raw.githubusercontent.com/blinkreaction/drude/develop/bin/dsh -o /usr/local/bin/dsh
    sudo chmod +x /usr/local/bin/dsh

<a name="setup"></a>
## Setup

Drude initial configuration is done once per project (e.g. by a team lead).  
`docker-compose.yml` file and optional `.drude` folder are good indicators of Drude's presence in the project repo.  
To use Drude each team member will need to follow this instruction.

#### Hardware requirements
While Docker is supported natively on Linux, Mac and Windows users will need a tiny linux VM layer - [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant). [VirtualBox](https://www.virtualbox.org/) and our Boot2docker Vagrant Box will be installed for you if you follow the instructions.  

- Boot2docker Vagrant Box requires 2GB of RAM by default. You need minimum 4GB RAM on your computer.  
- Your CPU should support hardware VT-x/AMD-V virtualization. (most modern CPUs)

#### Directory structure
Drude enforces directory structure where you have arbitrary located `projects` folder in which you place subfolder for each project you have.  
Dsh will put `Vagrantfile` and `vagrant.yml` into the `projects` folder.

```
+ ...
 - projects
 |--- drupal-site-1
 |      docker-compose.yml
 |      docroot
 |      ...
 | 
 |--- drupal-site-2
 |      .drude
 |      docker-compose.yml
 |      docroot
 |      ...
 | 
 |--- Vagrantfile
 |--- vagrant.yml
```
### Mac

 1. Edit `settings.php` for your site (see [Drupal settings](#drupal-settings) below).
 2. Open Terminal and cd into `<projects/your-drupal-site>`
 
    2.1) If you have never used Drude before run:
    ```
    dsh install
    ```
    This will install/update all required prerequisites. They include [Homebrew](http://brew.sh/), [Homebrew-cask](https://github.com/caskroom/homebrew-cask), VirtualBox, Vagrant, docker, docker-compose.
    
    2.2) If you already use Drude and just need to initialize new project run:
    ```
    dsh install drude
    ```
    This will ony download latest `docker-compose.yml` with default containers' settings.
    
 3. Start VM and containers with `dsh up`

### Windows

 1. Make sure your `projects` folder is **not** inside `%USERPROFILE%/.babun` installation folder.
 2. Edit `settings.php` for your site (see [Drupal settings](#drupal-settings) below).
 3. **In Babun shell** cd into `<projects/your-drupal-site>`
 
    3.1) If you have never used Drude before run:
    ```
    dsh install
    ```
    This will install/update all required prerequisites. They include [Chocolatey](https://chocolatey.org/), VirtualBox, Vagrant, docker, docker-compose.
    
    3.2) If you already use Drude and just need to initialize new project run:
    ```
    dsh install drude
    ```
    This will ony download latest `docker-compose.yml` with default containers' settings.
    
 4. Configure Volumes in your `docker-compose.yml` to use absolute paths formatted in the following way.  
 Suppose you have following file you need to map into db container to customize MySQL settings:

 ```
 c:\work\projects\project\.drude\etc\mysql\my.cnf

 Or same in Babun (cygwin) notation:

 /cygdrive/c/work/projects/project/.drude/etc/mysql/my.cnf

 ```
 Use following path in `docker-compose.yml`:

 ```
 /work/projects/project/.drude/etc/mysql/my.cnf
 ```
 In this case DB container "volumes" section should look like this:

 ```
 volumes:
   # MySQL configuration overrides
   - "/work/projects/project/.drude/etc/mysql/my.cnf:/etc/mysql/conf.d/z_my.cnf"
 ```
 
 5. Start VM and containers with `dsh up`
 
### Linux

 1. [Install Docker](https://docs.docker.com/compose/install/#install-docker)
 2. [Install Docker Compose](https://docs.docker.com/compose/install/#install-compose)
 3. Make sure your site's docroot is in `</path/to/project>/docroot`.
 4. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 5. cd `</path/to/project>` and run:

    ```
    dsh install
    ```

 6. Start containers with `dsh up`

<a name="updates"></a>
## Updates

 1. Run the following from the `</path/to/project>` folder:
 
    ```
    dsh update
    ```
    **Note**: This will overwrite your `docker-compose.yml`. If you have it customized but not controlled by git please make backup first.
    
    **Note**: if docker image for database container was updated then container will be re-created and you will need to _re-import your database._ 
    
    **Note Windows and Mac users:** if boot2docker VM image was updated then update will warn you that VM will be re-created. It means you will have to _re-import your database._ 

<a name="drupal-settings"></a>
## Drupal settings

Below you will find instructions on configuring you Drupal project to work with Drude.
Some settings are required, others are optional or enahncements. Please review carefully.

**Required**
- [DB connection settings](docs/drupal-settings.md#db)
- [File permissions fix](docs/drupal-settings.md#file-permissions)

**Optional**
- [Memcache settings](docs/drupal-settings.md#memcache)

<a name="dsh"></a>
## Drude Shell Helper (dsh)

Drude shell helper is a console tool that simplifies day-to-day work with Drude.
It provides a set of most commonly used commands and operations for controlling the Boot2docker VM, containers, running drush or other commands inside the **cli** container. (**Note**: dsh requires cli container to function properly)

See `dsh help` for a complete list.

`dsh` detects the environment it's launched in and will automatically start the boot2docker VM and launch containers as necessary.
It runs on Mac/Linux directly. On Windows `dsh` runs inside the boot2docker VM.

<a name="cli"></a>
## Console tools (cli)

**cli** container is meant to serve as a single console to access all necessary command line tools.
You can access **cli** container's console with `dsh`:

    dsh bash

Tools available inside the **cli** container:

- php-cli, composer, drush7
- ruby, bundler
- node, npm, bower, grunt
- git, wget, zip, mysql-client
- python

<a name="instructions"></a>
## Instructions and tutorials

- [Running multiple projects](docs/multiple-projects.md)
- [Overriding default PHP/MySQL/etc. settings](docs/settings.md)
- [Public access](docs/public-access.md)
- [DB sandbox mode](docs/db-sandbox.md)
- [Using Behat](docs/behat.md)

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
