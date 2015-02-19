# docker-fig-drupal
Docker and Fig based environment for Drupal.

## Requirements
1. OSX/Windows: [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant)
2. OSX/Linux: [Docker](https://www.docker.com/). Optional, but recommended on OSX. Available in the Vagrant box.
3. OSX/Linux: [Fig](http://www.fig.sh/). Optional, but recommended on OSX. Available in the Vagrant box.

## Usage
 1. Download or clone this repo and copy `fig.yml` and `.docker` into your Drupal project folder (`</path/to/project>`).
 2. Make sure your docroot is in `</path/to/project>/docroot`
 3. Edit DB connection settings in settings.php for the site (see below).
 4. If using [Boot2docker Vagrant Box](https://github.com/blinkreaction/boot2docker-vagrant): `vagrant up`
 5. `fig up -d`
 
## DB connection settings

Containers do not have static IP addresses assigned. 
DB connection settings can be obtained from the environment variables.  
Below are sample settings for Drupal 7 and Drupal8.  
If you change the DB node name in fig.yml (e.g. `mysql` instead of `db`) 
then this has to be updated, since variable names will change as well.

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

## File permissions fix

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
