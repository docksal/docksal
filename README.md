# Drude (**Dru**pal **D**ocker **E**nvironment)

Docker and Docker Compose based environment for Drupal.

**For a fully working example of Drude setup take a loot at:**
 - [Drupal 7 sample project](https://github.com/blinkreaction/drude-d7-testing)
 - [Drupal 8 sample project](https://github.com/blinkreaction/drude-d8-testing)


## System requirements

Please review [system requirements](docs/system-requirements.md) before proceeding with the setup.


<a name="setup"></a>
## Setup

Initial configuration is done once per project (e.g. by a team lead) and committed into the project repo. 
`docker-compose.yml` file and an optional `.drude` folder are good indicators that a project is using Drude.  

Drude expects a particular [directory structure](docs/system-requirements.md). Please review it before proceeding with the setup.

### Step 0: Install Babun (Windows only)

[Babun](http://babun.github.io) is a very nice Linux-type shell for Windows.  
Install it as a regular user (do not use admin command prompt).  
**Drude is not tested and may not work with any other shell on Windows.**

### Step 1: Install dsh (Drude Shell Helper)

dsh will automate the rest of the setup steps and will be used to control a Drude powered environment.

    sudo curl -L https://raw.githubusercontent.com/blinkreaction/drude/master/bin/dsh -o /usr/local/bin/dsh
    sudo chmod +x /usr/local/bin/dsh

dsh works and is supported on Mac, Windows (in Babun shell), Linux and [boot2docker-vagrant](https://github.com/blinkreaction/boot2docker-vagrant).

### Step 2: Mac

 1. Edit `settings.php` for your site (see [Drupal settings](#drupal-settings) below).
 2. Open Terminal and cd into `<projects/your-drupal-site>`
 
    2.1) If you have never used Drude before run:
    ```
    dsh install
    ```
    This will install/update all required prerequisites: [Homebrew](http://brew.sh/), [Homebrew-cask](https://github.com/caskroom/homebrew-cask), VirtualBox, Vagrant, docker, docker-compose.
    
    2.2) If you are already using Drude on other projects and just need to initialize a new one run:
    ```
    dsh install drude
    ```
    This will ony download latest `docker-compose.yml` with default containers' settings.
    
 3. Start VM and containers with `dsh up`

### Step 2: Windows

 1. Make sure your `projects` folder is **not** inside `%USERPROFILE%/.babun` installation folder.
 2. Edit `settings.php` for your site (see [Drupal settings](#drupal-settings) below).
 3. **In Babun shell** cd into `<projects/your-drupal-site>`
 
    3.1) If you have never used Drude before run:
    ```
    dsh install
    ```
    This will install/update all required prerequisites: [Chocolatey](https://chocolatey.org/), VirtualBox, Vagrant, docker, docker-compose.
    
    3.2) If you are already using Drude on other projects and just need to initialize a new one run:
    ```
    dsh install drude
    ```
    This will ony download latest `docker-compose.yml` with default containers' settings.
    
 4. Start VM and containers with `dsh up`
 
### Step 2: Linux

 1. [Install Docker](https://docs.docker.com/compose/install/#install-docker)
 2. [Install Docker Compose](https://docs.docker.com/compose/install/#install-compose)
 3. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 4. If you don't have your `docker-compose.yml` and would like to initialize a new Drude project cd `<projects/your-drupal-site>` and run:
 
    ```
    dsh install drude
    ```
    This will ony download latest `docker-compose.yml` with default containers' settings.

 5. Start containers with `dsh up`

<a name="updates"></a>
## Updates

 1. Updating Dsh. It **recommended to always update Dsh before updating Drude** as new version of Dsh may contain changes or improvements to update process. Anywhere run

        dsh self-update

 2. Updating Drude. Run the following from the `<projects/your-drupal-site>` folder:
 
        dsh update

    **Note**: if docker image for database container was updated then container will be re-created and you will need to _re-import your database._ 
    
    **Note Windows and Mac users:** if boot2docker VM image was updated then update will warn you that VM will be re-created. It means you will have to _re-import your databases._ 

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
It runs on Mac/Linux directly. On Windows `dsh` runs inside the Babun Shell.

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
- [Zero-configuration Debugging with Xdebug and PhpStorm](docs/xdebug.md)

<a name="troubleshooting"></a>
## Troubleshooting

See [Troubleshooting](docs/troubleshooting.md) section of the docs.

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
