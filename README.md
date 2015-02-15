# docker-fig-drupal
Docker and Fig based environment for Drupal

## Requirements
1. [Docker](https://www.docker.com/)
2. [Fig](http://www.fig.sh/)
3. Mac-only: [Boot2docker w/ NFS](https://github.com/blinkreaction/boot2docker-vagrant-nfs)

## Usage
 1. Clone this repo and copy `fig.yml` and `.docker` into your Drupal project folder (`</path/to/project>`).
 2. Make sure your docroot is in `</path/to/project>/docroot`
 3. Edit DB connection settings in settings.php for the site (see below).
 4. `fig up -d`
 
## DB connection settings

```php
$databases = array (
  'default' => 
  array (
    'default' => 
    array (
      'database' => $_SERVER['MYSQL_ENV_MYSQL_DATABASE'],
      'username' => $_SERVER['MYSQL_ENV_MYSQL_USER'],
      'password' => $_SERVER['MYSQL_ENV_MYSQL_PASSWORD'],
      'host' => $_SERVER['MYSQL_PORT_3306_TCP_ADDR'],
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',
    ),
  ),
);

```
