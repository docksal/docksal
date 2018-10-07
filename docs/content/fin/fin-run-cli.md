---
title: "fin run-cli (rc)"
weight: 3
---

## Disposable cli environments

With this command you can launch a standalone `cli` container within the scope of the current directory.
The directory is mapped into `/var/www` in the container.

This gives you access to all of the tools available in `docksal/cli` without launching an entire Docksal stack.
This also eliminates the need of having any of the console tools installed locally on the host.


## Example uses

### Run a script in a disposable environment

You can run any scripts (PHP, Python, Ruby, Nodejs, Bash, etc.) in a safe, disposable environment:

```bash
fin run-cli <script-file-name>
```

The container will only have access to the current directory scope on the host.
The results of the execution can be stored in the same directory.

Any other changes happen inside of the container only and are reset once the container is stopped.


### Create a Drupal 8 Composer based project from scratch

```bash
fin run-cli composer create-project drupal-composer/drupal-project:8.x-dev myproject --stability dev --no-interaction
```

You can then initialize the default Docksal stack (LAMP) for the new project with just a few more steps:

```bash
cd myproject
mkdir .docksal
fin config set DOCROOT=web
fin project start
``` 


## Data persistence

Generally, anything you do inside of a `fun run-cli` environment is gone once the container is stopped.
You can install new packages, run scripts, break things, etc., without the risk of damaging your host system.
The next time you do `fin run-cli`, the `run-cli` environment is started fresh and clean.

The only exceptions are:

- the current directory on the host (mapped to `/var/www` inside the container)
- the `$HOME` (`/home/docker`) directory inside the container

With `/home/docker` directory persisting between `fin run-cli` executions you get the benefit of a shared cache space.

You have the option to override this behavior and launch the container without the persistent `$HOME` volume:

```bash
fin run-cli --clean
```

Note: this does not drop the shared `$HOME` volume used for regular `fin run-cli` executions.

You can wipe the shared `$HOME` volume with:

```bash
fin run-cli --cleanup
```

See `fin help run-cli` for more details.
