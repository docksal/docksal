# Drupal settings

Below you will find instructions on configuring your Drupal project to work with Docksal.
Some settings are required; others are optional or enhancements. Please review carefully.

<a name="db"></a>
# DB connection settings (**required**)

Containers do not have static IP addresses assigned.  DB connection settings can be obtained from the environment variables.

Below are sample settings for Drupal 7 and Drupal8.
If you change the DB node name in `docksal.yml` (e.g. `mysql` instead of `db`) then this has to be updated, since variable names will change as well.

**Drupal 7 and 8**

```php
# Docksal DB connection settings.
$databases['default']['default'] = array (
  'database' => getenv('DB_1_ENV_MYSQL_DATABASE'),
  'username' => getenv('DB_1_ENV_MYSQL_USER'),
  'password' => getenv('DB_1_ENV_MYSQL_PASSWORD'),
  'host' => getenv('DB_1_PORT_3306_TCP_ADDR'),
  'driver' => 'mysql',
);
```

<a name="file-permissions"></a>
## File permissions fix (**required**)

With NFS mounts, Drupal may complain about the files directory not being writable. This is a "false-negative", however it can be annoying and break certain things. For a workaround, add the following to your setting.php file.

**Drupal 7**

```php
# Workaround for permission issues with NFS shares in Vagrant
$conf['file_chmod_directory'] = 0777;
$conf['file_chmod_file'] = 0666;
```

**Drupal 8**

```php
# Workaround for permission issues with NFS shares in Vagrant
$settings['file_chmod_directory'] = 0777;
$settings['file_chmod_file'] = 0666;
```

You may also have to reset permissions on the existing files folder. The following command will recursively set folders to 777 (rwx) and files to 666 (rw).

```bash
chmod -R +rwX files
```

<a name="reverse-proxy"></a>
## Reverse proxy settings (**optional**)

In some cases you need to let Drual know if HTTPS is used by client. Add the following lines to settings.php:

**Drupal 7**

```php
# Reverse proxy configuration (Docksal's vhost-proxy)
$conf['reverse_proxy'] = TRUE;
$conf['reverse_proxy_addresses'] = array($_SERVER['REMOTE_ADDR']);
// HTTPS behind reverse-proxy
if (
  isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' &&
  !empty($conf['reverse_proxy']) && in_array($_SERVER['REMOTE_ADDR'], $conf['reverse_proxy_addresses'])
) {
  $_SERVER['HTTPS'] = 'on';
  // This is hardcoded because there is no header specifying the original port.
  $_SERVER['SERVER_PORT'] = 443;
}
```

**Drupal 8**

```php
# Reverse proxy configuration (Docksal's vhost-proxy)
$settings['reverse_proxy'] = TRUE;
$settings['reverse_proxy_addresses'] = array($_SERVER['REMOTE_ADDR']);
// HTTPS behind reverse-proxy
if (
  isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' &&
  !empty($settings['reverse_proxy']) && in_array($_SERVER['REMOTE_ADDR'], $settings['reverse_proxy_addresses'])
) {
  $_SERVER['HTTPS'] = 'on';
  // This is hardcoded because there is no header specifying the original port.
  $_SERVER['SERVER_PORT'] = 443;
}
```

<a name="memcache"></a>
## Memcache settings (**optional**)

**Drupal 7**

Add the following lines to `settings.php` to point Drupal to the memcached node. Replace `</path/to/memcache-module>` with path to [memcache module](https://www.drupal.org/project/memcache) in your project. E.g. `sites/all/modules/contrib/memcache`

```php
// Memcache
$conf['cache_backends'][] = '</path/to/memcache-module>/memcache.inc';
$conf['cache_default_class'] = 'MemCacheDrupal';
$conf['cache_class_cache_form'] = 'DrupalDatabaseCache';
$conf['memcache_servers'] = array(
  'memcached.hello-world.docker:11211' => 'default',
);
```
