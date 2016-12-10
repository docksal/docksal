# Configure a project to use Docksal

Docksal is capable of running a project without specifying a configuration for a project. 
It has a default configuration it will use to build containers and setup a virtual host.

Initial configuration is done once per project (e.g. by a team lead) and committed into the project repo. 
Presence of the `.docksal` folder in the project directory is a good indicator a project is already using Docksal.

## Default setup

#### 1. Create a project directory (or checkout your existing project).

```
mkdir ~/projects/myproject
cd ~/projects/myproject
```

#### 2. Create an empty `.docksal` directory. 

`mkdir .docksal`

All project specific configurations and commands will be stored in this directory.

!!! note "Version control" 
    Git does not commit empty directories. To commit it to Git repo create a .gitkeep file inside it with `touch .docksal/.gitkeep`

#### 3. Start the project containers.

`fin start`

You should see output like the following:

```
Starting services...
Creating network "myproject_default" with the default driver
Creating volume "myproject_project_root" with local driver
Creating volume "myproject_host_home" with local driver
Creating myproject_cli_1
Creating myproject_db_1
Creating myproject_web_1
Changing user id in cli to 501 to match host user id...
Resetting permissions on /var/www...
Restarting php daemon...
Connected vhost-proxy to "myproject_default" network.
```

!!! tip "SSH key password"
    If you are being asked for password to SSH keys `id_dsa` or `id_rsa`, please know that these are **your** keys that were copied over from your `~/.ssh` folder into SSH Agent's container. Their paths looks like `/root/.ssh/...` because that's the path **inside container**. Please provide password(s) to your keys if you want to use git or drush commands that require your SSH keys within Docksal (e.g. often project init script or composer script contains repository checkout that would require your key).

#### 4. Setup document root and create index file

To have a working site, you need to add a document root and start adding files. If your project is empty then create a new `docroot` folder and `index.html` or `index.php` inside it.

In this docroot folder you can add any project files you want: a plain HTML, PHP-based CMS or pure PHP project.

#### 5. Done

Your project site is now running. You can visit project url in your browser `http://myproject.docksal`

!!! tip "VIRTUAL HOST name"
    By default virtual host name is equal to project folder name sans spaces and dashes, with `.docksal` domain appended to it. `myproject => myproject.docksal`

!!! attention "Windows users need HOSTS file configuration"
    On Windows you need to append your project to the hosts file for every project `192.168.64.100  myproject.docksal`

## Checking the default configuration

If you had setup a project using the simplified process above, then Docksal will handle all the configuration
behind the scenes. To review the configuration, type `fin config` in your project directory.

You will see output similar to the following:

```
COMPOSE_PROJECT_NAME: myproject
COMPOSE_PROJECT_NAME_SAFE: myproject
COMPOSE_FILE:
/Users/testuser/.docksal/stacks/volumes-bind.yml
/Users/testuser/.docksal/stacks/stack-default.yml
ENV_FILE:


PROJECT_ROOT: /Users/testuser/projects/myproject
DOCROOT: docroot
VIRTUAL_HOST: myproject.docksal
IP: 192.168.64.100

MYSQL_PORT:

Docker Compose configuration
---------------------
networks: {}
services:
  cli:
    hostname: cli
    image: docksal/cli:1.0-php7
    volumes:
    - host_home:/.home:ro
    - docksal_ssh_agent:/.ssh-agent:ro
    - project_root:/var/www:rw
  db:
    environment:
      MYSQL_DATABASE: default
      MYSQL_PASSWORD: user
      MYSQL_ROOT_PASSWORD: root
      MYSQL_USER: user
    hostname: db
    image: docksal/db:1.0-mysql-5.5
  web:
    depends_on:
    - cli
    environment:
      APACHE_DOCUMENTROOT: /var/www/docroot
      VIRTUAL_HOST: myproject.docksal
    hostname: web
    image: docksal/web:1.0-apache2.2
    labels:
      io.docksal.project-root: /Users/testuser/projects/myproject
      io.docksal.virtual-host: myproject.docksal
    volumes:
    - project_root:/var/www:ro
version: '2.0'
volumes:
  docksal_ssh_agent:
    external: true
    external_name: docksal_ssh_agent
  host_home:
    driver: local
    driver_opts:
      device: /Users/testuser
      o: bind
      type: none
  project_root:
    driver: local
    driver_opts:
      device: /Users/testuser/projects/myproject
      o: bind
      type: none

---------------------
```

Note that it displays the virtual host name it will use, which is based on your
project's directory name, and it displays the MySQL user name and password if
you need to setup a database.

## Customizing a configuration

If you need to customize your Docksal setup, there is a command to build the initial configuration files.

`fin config generate`

This will save the default dynamic configuration to files in the `.docksal` directory.

- `docksal.yml` is for Docker specific configuration, like adding or removing services.
- `docksal.env` is for environment specific configuration, like setting the document root or hostname.

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](custom-commands.md).  
E.g. `fin init`, which will call `.docksal/commands/init`. Put project specific initialization tasks there, like:

- initialize Docksal configuration
- import database or perform a site install
- compile SASS
- run DB updates, special commands, etc.
- run Behat tests

For a fully working example of a Docksal powered project (including `fin init`) take a look at:

- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)
- [WordPress sample project](https://github.com/docksal/wordpress)
