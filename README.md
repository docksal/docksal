# docker-drupal
Docker and Docker Compose based environment for Drupal.

## Requirements

### Mac and Windows
Docker is not supported natively on Mac and requires a Docker Host VM - [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant)

On Mac both [Docker](https://docs.docker.com/compose/install/#install-docker) and [Docker Compose](https://docs.docker.com/compose/install/#install-compose) can be installed and used natively.

They are preinstalled and can be used inside the Docker Host VM.  This is also the only option available for Windows right now:

    vagrant ssh
    docker version
    docker-compose --version

### Linux
1. [Docker](https://docs.docker.com/compose/install/#install-docker)
2. [Docker Compose](https://docs.docker.com/compose/install/#install-compose)

## Usage
 1. Copy `docker-compose.yml` and `.docker` into your Drupal project folder (`</path/to/project>`).
 2. Make sure your docroot is in `</path/to/project>/docroot`
 3. Edit `settings.php` for the site (see [Drupal settings](#drupal-settings) below).
 4. cd `</path/to/project>` and continue with the steps below depending on your OS.

### Mac
If you have not installed Docker and Docker Compose - skip down to Windows instructions. Otherwise:

    vagrant up
    docker-compose up -d

### Windows

    vagrant up
    vagrant ssh
    cd </path/to/project>
    docker-compose up -d

### Linux

    docker-compose -d
 
## <a name="drupal-settings"></a> Drupal settings

### DB connection settings

Containers do not have static IP addresses assigned.  DB connection settings can be obtained from the environment variables.

Below are sample settings for Drupal 7 and Drupal8.  
If you change the DB node name in `docker-compose.yml` (e.g. `mysql` instead of `db`) then this has to be updated, since variable names will change as well.

**Drupal 7**

```php
$databases = array (
  'default' => 
  array (
    'default' => 
    array (
      'database' => getenv('DB_1_ENV_MYSQL_DATABASE'),
      'username' => getenv('DB_1_ENV_MYSQL_USER'),
      'password' => getenv('DB_1_ENV_MYSQL_PASSWORD'),
      'host' => getenv('DB_1_PORT_3306_TCP_ADDR'),
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);

```

**Drupal 8**

```php
$databases['default']['default'] = array (
  'database' => getenv('DB_1_ENV_MYSQL_DATABASE'),
  'username' => getenv('DB_1_ENV_MYSQL_USER'),
  'password' => getenv('DB_1_ENV_MYSQL_PASSWORD'),
  'prefix' => '',
  'host' => getenv('DB_1_PORT_3306_TCP_ADDR'),
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
```

### File permissions fix

With NFS mounts Drupal may complain about files directory not being writable. This is a "false-negative" however can be annoying and break certain things. For a workaround add the following to your setting.php file. 

**Drupal 7**

```php
# Workaround for permission issues with NFS shares in Vagrant
$conf['file_chmod_directory'] = 0777;
$conf['file_chmod_file'] = 0666;
```

You may also have to reset permissions on the existing files folder. The following command will recursively set folders to 777 (rwx) and files to 666 (rw)

```bash
chmod -R +rwX files
```

## Tips and tricks

### Runnig Drush

Drush is available inside the **web** container. To run it first open bash inside **web**:

    docker exec -it $(fig ps -q web) bash

A more convenient way of running Drush is via the [docker-drush](.docker/bin/docker-drush) wrapper:

    .docker/bin/docker-drush st

To make the wrapper available in your shell directly (as `docker-drush`) add the following to your `~/.bash_profile`:

    # Docker custom project scripts
    export PATH="./.docker/bin:$PATH"

This will work universally on all projects using this repo.

### Available wrapper scripts

 - [docker-bash](.docker/bin/docker-bash)- launches bash inside the web container
 - [docker-drush](.docker/bin/docker-drush) - launches drsuh inside the web container

## Altering PHP and MySQL configuration

The following configuration files are mounted inside the respective containers and can be used to override the default settings:

- [.docker/etc/php5/php.ini](.docker/etc/php5/php.ini) - PHP settings overrides
- [.docker/etc/mysql/my.cnf](.docker/etc/mysql/my.cnf) - MySQL settings overrides

