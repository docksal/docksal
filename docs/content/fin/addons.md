---
title: "Addons"
---

In addition to the custom commands it is possible to extend fin further with addons per project or per host.

Addons by default can be found in the [Docksal Addons Repository](https://github.com/docksal/addons).
In order to use addons, fin version 1.7.0 or higher is required.

## Installing To Project

Installing an addon can be as simple executing the `addon` command within the project that the addon should be added for.

```bash
fin addon install <name>
```

Fin will first look for the addon in the `~/.docksal/addons` directory. If it is not located there, then it will attempt to search the [Docksal Addons Repository](https://github.com/docksal/addons).

## Removing From Project

To remove an addon run:

```bash
fin addon remove <name>
```

## Current List of Addons

Here is a list of already created addons that can help extend functionality for your project.

|   Name	|  Description 	|  Requirements 	|
|--- |--- |--- |
|   example	|  A working documentation on what is Docksal addon and how it works 	|  |
|   adminer | [Adminer](https://www.adminer.org/) database management tool | MySQL |
|   codeclimate | [CodeClimate](https://codeclimate.com/) code quality tool | |
|   mailhog | [Mailhog](https://github.com/mailhog/MailHog) e-mail capture service for current project |  |
|   phpunit | Creates a phpunit.xml file and runs PHPUnit tests | Drupal |
|   pma | [PhpMyAdmin](https://www.phpmyadmin.net/) database management tool | MySQL |
|   redis | Add [Redis](https://redis.io/) to current project |  |
|   sequelpro | Launches [SequelPro](https://www.sequelpro.com) with the connection information for current project. | macOS |
|   solr | [Apache Solr](http://lucene.apache.org/solr/) search service for current project |  |
|   uli | Generate one time login url for current site | Drupal |

__NOTE:__ This list may not be up to date. To see a more comprehensive list consult the [Docksal Addons Repository](https://github.com/docksal/addons). 

## Creating Addons

To create an addon the following [example](https://github.com/docksal/addons/tree/master/example) can be followed.

Other than that, the bare minimum is necessary.

* A folder that is the name of your addon. **Careful** when choosing a name make sure it is a machine readable name. Meaning
letters, numbers, dashes, and underscores. All other characters should be avoided.
* Next, create a file within that addon folder that is the same name as the addon. This is where the base of the addon command will
live. Example if my addon's name was `example`, my folder structure would look like `example/example`.

```bash
#!/usr/bin/env bash

VERSION="1.0"

## Example addon
##
## This is an example addon. It's purpose is to show sample folder structure
## and concepts of creating addons.
##
##   fin example <command>
##
## Usage:
##   hello      Say Hello!
##   version     Display addon version


case "$1" in
	hello)
		echo "Hello!"
		;;
	version|-v)
		echo "$VERSION"
		;;
	*)
		fin help example
		;;
esac
```

* Lastly, create a file that is the same name as the addon with the extension `.filelist` at the end of it. Example if my addon's name was `example`, it would be `example/example.filelist`. This file will contain any additional files within the addon folder that should be included at the time of install.

```bash
# If you want to include more than a single script file,
# you do it by creating addon.filelist file
# where all additional files should be described.
# One line per file, paths relative to current folder.

# Here is additional files
some-additional-files/somefile

# If you want to use hooks they should also be included here
# or they won't get downloaded and executed
example.pre-install
example.post-install
example.pre-uninstall
example.post-uninstall
```

### Install Hooks for an Addon

When adding or removing an addon, it can contain a set of pre and post commands that will be executed. Example use cases would be to add/remove a service to the projects `docksal.yml`. Each use case will vary but they are available for use if necessary. For instance, an addon named `example` that needs to execute a process before it is installed would be be located in the file named `example/example.pre-install`. This file should also be included within the `example/example.filelist` file as noted above.


Phase | Process | File Extension
------|---------|----------------
Before | Install | `.pre-install`
After | Install | `.post-install`
Before | Uninstall | `.pre-uninstall`
After | Uninstall | `.post-install`
