# Drupal settings

<a name="db"></a>
# DB connection settings

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

<a name="file-permissions"></a>
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

<a name="memcache"></a>
## Memcache settings

1. Uncomment the **memcached** service definition section in [`docker-compose.yml`](docker-compose.yml) to start using memcached.

2. Add the following lines to `settings.php` to point Drupal to the memcached node. Replace `</path/to/memcache-module>` with path to [memcache module](https://www.drupal.org/project/memcache) in your project. E.g. `sites/all/modules/contrib/memcache`

```php
// Memcache
$conf['cache_backends'][] = '</path/to/memcache-module>/memcache.inc';
$conf['cache_default_class'] = 'MemCacheDrupal';
$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';
$conf['memcache_servers'] = array(
  'memcached:11211' => 'default',
);
```
