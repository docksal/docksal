# Overriding default PHP/MySQL/etc. settings

<a name="configuration"></a>
## Altering PHP and MySQL configuration

When the following configuration files are added within a project, they can be used to override default settings:

- `.docksal/etc/php/php.ini` - PHP settings overrides
- `.docksal/etc/php/php-cli.ini` - command line PHP settings overrides
- `.docksal/etc/mysql/my.cnf` - MySQL settings overrides

Copy `examples/.docksal/etc` from the [Docksal project](https://github.com/docksal/docksal) into the `.docksal` folder in your project repo and modify as necessary.

<a name="php-versions"></a>
## Using different PHP versions

Switching PHP versions is done via the `docksal/drupal-cli` docker image tags. See which images are available on [Docker Hub](https://hub.docker.com/r/docksal/cli/). To
make these changes you must have project configuration files. See [Project Setup](project-setup.md)

To switch to a different image tag:

1) open the project's `.docksal/docksal.yml` file  
2) under the `cli` section, add the `image` property.

By default, it looks like this:

```
# CLI node
  cli:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: cli
```

Add the `image` property to override the docker image used:

```
# CLI node
  cli:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
    image: docksal/cli:1.0-php7
```

See the list of available tags below and on [Docker Hub](https://hub.docker.com/r/docksal/cli/tags/).

3) run `fin up`. This will update the project's configuration.

Available PHP versions:

- `5.x` (`image: docksal/cli:1.0-php5`) - default
- `7.x` (`image: docksal/cli:1.0-php7`) - experimental

<a name="mysql-versions"></a>
## Using different MySQL versions

Switching MySQL versions is done via the `docksal/db` docker image tags.

To switch to a different image tag follow the same instructions as above, but 
modify the `db` configuration. You can find tagged `db` images on [Docker Hub](https://hub.docker.com/r/docksal/db/tags/).

When done, always remember to run `fin up` to update the project's configuration.

- `5.5` (`image: docksal/db:1.0-mysql-5.5`)
- `5.6` (`image: docksal/db:1.0-mysql-5.6`)
- `5.7` (`image: docksal/db:1.0-mysql-5.7`)
