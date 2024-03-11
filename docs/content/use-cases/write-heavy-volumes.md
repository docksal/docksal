---
title: "Increasing Performance by Keeping Write-heavy Volumes Inside Containers"
weight: 1
---

Depending on the operating system of your host machine, you may run into some performance issues related to the read/write
speed between your host machine and your Docksal application. The section on [Docksal Volumes](/core/volumes) outlines different types
of mounts available with Docksal, however any non-Linux host machine will take a performance hit.

There are a few options for boosting the speed of your application available, as noted in the [Docksal Volumes](/core/volumes) section,
but another potential method of boosting performance is to keep write-heavy volumes inside the containers so that Docksal does not
need to rely on mounts to the host to read or write data.

The process of keeping write-heavy volumes inside containers involves mounting certain folders as volumes within the CLI container and
interacting with the data directly through the container. For example, in a Composer-based Drupal project, the `/vendor` folder is usually pretty large
and includes a lot of functionality and code that Drupal needs to run. In a standard Docksal application, the process for interacting with these files is
similar to this:
```
macOS Host ==============> Docker Desktop ==============> Container
(~/project/vendor)                                        (/var/www/vendor)
```

If you mount the write-heavy folder as a volume directly inside a container, the container's filesystem can interact with it at native filesystem speeds, because the files exist within the container instead of mounted from the host.

The downside to this is that changes to the files in these folders on the host are not reflected in the container and vice versa, however a command can be written
to sync between the host and container.

A basic example of this would be to mount the `vendor` and the `docroot/modules/contrib` folders in a standard, Composer-based Drupal project.

In your `docksal.yml` file, you would have something like this:

```yaml
version: 3.9
services:
  cli:
    volumes:
      # Mount the vendor and contrib folders to volumes within the container.
      - drupal_vendor:/var/www/vendor
      - drupal_contrib:/var/www/docroot/modules/contrib
volumes:
  # Define the volumes.
  drupal_vendor:
  drupal_contrib:
```

There is a more verbose example of this type of customization in the [Drupal + GatsbyJS Boilerplate docksal.yml](https://github.com/docksal/boilerplate-drupal-gatsby/blob/master/.docksal/docksal.yml).

{{% notice note %}}
There does not need to be anything after the `:` in the `volumes:` section of your `docksal.yml`. This defines the named volumes. No further settings are required.
{{% /notice %}}

Now when you spin up your project, instead of mounting these folders from the host machine, separate, empty volumes will be created
and mounted at the defined locations within your container.

Because these volumes are only accessible within the container, any commands that interact with them _MUST_ be run within the container. For example,
if you normally run `composer install` outside of the container and rely on the bind mount to link the host data to the container data, you will need
to change your workflow to either running `fin composer install` or working within the container using `fin bash`.

{{% notice note %}}
By default, Docksal ships with many command line development tools like Composer and NPM. Running these commands in the container will not require you
to install any additional software or customize your `cli` container any further. For a list of utilities that are available, please see the [Tools and Integrations](/tools)
section of the docs.
{{% /notice %}}

Because the files now live within the containers instead of being shared between host and container, this may result in some changes to your workflow.
If you need to sync data between the container and host in order to set Xdebug breakpoints on a Composer package, or debug a contributed module, you will need to manually
sync the data as needed.

One method of syncing between host and container is using [rsync](https://rsync.samba.org/) with Docker. The format for this command, when run from the host machine, is:

```
rsync -e 'docker exec -i' -avP [-r] [SOURCE] [DESTINATION]
```

The `-r` flag determines whether or not to delete files on the destination that are not on the source.

Assuming that your `cli` container is named `drupal9`, the command to sync the `vendor` folder from container to host without deleting files would be:

```
rsync -e 'docker exec -i' -avP drupal9_cli_1:/var/www/vendor ./vendor
```

To sync from the `vendor` folder from your host to the container, deleting any files that are not on the host:

```
rsync -e 'docker exec -i' -avP -r ./vendor drupal9_cli_1:/var/www/vendor
```

Regardless of whether the container is the source or the destination, the path will be `[CONTAINER NAME]:/path/to/folder`

{{% notice warning %}}
These commands can be destructive and may result in a loss of data if the paths are not correct. Use at your own risk.
{{% /notice %}}
