# Overriding default PHP/MySQL/etc. settings

<a name="configuration"></a>
## Altering PHP and MySQL configuration

The following configuration files are mounted inside the respective containers and can be used to override the default settings:

- `.drude/etc/php5/php.ini` - PHP settings overrides
- `.drude/etc/php5/php-cli.ini` - command line PHP settings overrides
- `.drude/etc/mysql/my.cnf` - MySQL settings overrides

Copy [examples/.drude](../examples/.drude) into the `/.drude` folder in your project repo and modify as necessary.

<a name="php-versions"></a>
## Using different PHP versions

Switching PHP versions is done via the `blinkreaction/drupal-cli` docker image tags.

To switch to a different image tag:

- open the `docker-compose.yml` file
- replace the `cli` service `image` property as necessary (see list of available tags below)
- run `dsh up`

Available PHP versions:

- `5.6` (`image: blinkreaction/drupal-cli:stable`) - default
- `7.0` (`image: blinkreaction/drupal-cli:php7`) - experimental

<a name="mysql-versions"></a>
## Using different MySQL versions

Switching MySQL versions is done via the `blinkreaction/drupal-mysql` docker image tags.

To switch to a different image tag:

- open the `docker-compose.yml` file
- replace the `db` service `image` property as necessary (see list of available tags below)
- run `dsh up`

Available MySQL versions:

- `5.5` (`image: blinkreaction/drupal-mysql:5.5`)
- `5.6` (`image: blinkreaction/drupal-mysql:5.6`) - default.
- `5.7` (`image: blinkreaction/drupal-mysql:5.7`)
