---
title: "On-demand Disposable CLI"
weight: 3
aliases:
  - /en/master/fin/fin-run-cli/
---

## Disposable CLI Environments

With this command you can launch a standalone `cli` container within the scope of the current directory.
The directory is mapped into `/var/www` in the container.

This gives you access to all of the tools available in `docksal/cli` without launching an entire Docksal stack.
This also eliminates the need of having any of the console tools present in `docksal/cli` installed locally on the host.


## Example Uses

### Run a Script in a Disposable Environment

You can run any Linux command or script (Bash, PHP, Python, Ruby, Nodejs, etc.) in a safe, disposable environment:

```bash
fin run-cli <command or script>
```

The container will only have access to the current directory scope on the host.
The results of the execution can be stored in the same directory.

Any other changes happen inside of the container only and are reset once the container is stopped.


### Create a Drupal 8 Composer-based Project from Scratch

```bash
fin run-cli composer create-project drupal/recommended-project myproject --no-interaction
```

You can then initialize the default Docksal stack (LAMP) for the new project with just a few more steps:

```bash
cd myproject
fin init
``` 


## Data Persistence

Generally, anything you do inside of a `fin run-cli` environment is gone once the container is stopped.
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
