# Overriding default PHP/MySQL/etc. settings

## Altering PHP and MySQL configuration

The following configuration files are mounted inside the respective containers and can be used to override the default settings:

- `.drude/etc/php5/php.ini` - PHP settings overrides
- `.drude/etc/php5/php-cli.ini` - command line PHP settings overrides
- `.drude/etc/mysql/my.cnf` - MySQL settings overrides

Copy [examples/.drude](../examples/.drude) into the `/.drude` folder in your project repo and modify as necessary.
