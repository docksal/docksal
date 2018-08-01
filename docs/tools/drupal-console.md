# Using Drupal Console

Drupal Console is a tool to generate boilerplate code, interact with, and debug Drupal.

Please refer to the official [Drupal Console docs](https://docs.drupalconsole.com/en/index.html) for usage details.

## Setup

Drupal Console is expected to be installed as a project level dependency via Composer.

```
# Change directory to Drupal site
cd /path/to/drupal8

# Download DrupalConsole
composer require drupal/console:~1.0 --prefer-dist --optimize-autoloader
```

A global Drupal Console Launcher is installed in the `cli` container and will pass the execution to the project level binary.

## Usage 

From the host via `fin`:

```
fin drupal --version
```

From with the cli container (`fin bash`) drush can be called directly:

```
drupal --version
```
