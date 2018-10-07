---
title: "Custom commands"
---

It is possible to extend fin with custom commands per project or per host.

## Project-level custom commands

Create a file at this location `.docksal/commands/updb` with the following contents:

```bash
#!/usr/bin/env bash

## Runs drush updb
##
## Usage: fin updb [params to passthrough]

fin drush updb $1
```
Note: the file name should match the command name with **no extension**.

Make the file executable:

```bash
chmod +x .docksal/commands/updb
```

Now you can use it as if it was a regular fin command: `fin updb`.
Passing parameters also works: `fin updb -y`.
The command description will be visible in `fin help` and the full command help will be available via `fin help updb`.

Note: `drush updb` is a Drupal-specific example.

## Available variables

These variables, provided by fin, are available for use inside you custom command scripts:

* `PROJECT_ROOT` - absolute path to the project folder
* `DOCROOT` - name of the docroot folder
* `VIRTUAL_HOST` - the virtual host name for the project (e.g., `projectname.docksal`)
* `DOCKER_RUNNING` - (string) "true" or "false"


Here is an example `init` command for a Drupal website using drush to automate the install:  

```bash
#!/usr/bin/env bash

# Start containers
fin up
# Install site
fin drush site-install -y --site-name="My Drupal site"
# Get login link
cd docroot 2>dev/null
fin drush uli
```

## Documenting custom command

Fin looks for lines starting with `##` for command documentation.

```bash
## Custom command description
## Usage: fin mycommand [--force]
## Parameters:
## --force Try really hard
```

Fin will output the first line of custom command documentation as the short description when using `fin help`.  
The rest of the lines will be available as advanced help via `fin help command_name`.

See an example of command documentation in the phpcs command (examples/.docksal/commands/phpcs located in the [Docksal project](https://github.com/docksal/docksal).)

## Global custom commands

Put your command in `$HOME/.docksal/commands` and it will be accessible globally.
This is useful for tedious tasks that you need in every project.

## Advanced use

It is not imperative to use bash. You can use any interpreter for your custom command scripts

```python
#!/usr/bin/env python

print "Custom python command!"
```

```node
#!/usr/bin/env node

/*
## Custom node command description
*/

console.log("Custom NodeJS command!")
```

Note in the above example for node, that custom command meta information lines are wrapped in a comment block
relevant to this interpreter.

## Executing commands inside cli

In some cases you'd want a command to be executed inside `cli` instead of the host (e.g., when you do not want to rely on
any dependencies installed on the host and use the tools available in `cli`).

One way to achieve this is to write two commands:

- one with the actual code, that you want to execute (e.g., `mycommand-cli`)
- one that does `fin exec '/var/www/.docksal/commands/mycommand-cli'` (e.g., `mycommand`)

Users can then run the command as `fin mycommand` to get the `mycommand-cli` executed in cli.

This approach may not be very convenient.

Alternatively the following notation inside a custom command can be used to tell fin to run the command inside cli:

```bash
#!/usr/bin/env bash

#: exec_target = cli

## Lists current directory inside cli

pwd
```

```node
#!/usr/bin/env node

/*
#: exec_target = cli

## Custom node command description
*/

console.log("Custom NodeJS command!")
```

Note in the above example for node, that custom command meta information lines are wrapped in a comment block
relevant to this interpreter.

When using `#: exec_target = cli` for commands you have to consider the following:

1. there is no `fin` in `cli`
2. calling other commands can be done via `${PROJECT_ROOT}/.docksal/commands/my-command` (which resolves to `/var/www/.docksal/commands/my-command` inside cli)
3. the command being called cannot use `fin` (due to 1)
4. variables defined in `docksal.env` are not passed to `cli` (though, they can be passed selectively via `docksal.yml`)

Here's how 4 can be handled:

**docksal.yml**

```yaml

version: '2.1'

services:
  cli:
    environment:
      # These variables are set here
      - ACAPI_EMAIL=email
      - ACAPI_KEY=key
      # These variables are passed from the host (including values in `docksal.env`/`docksal-local.env`)
      - SOURCE_ALIAS
      - VIRTUAL_HOST
```

## Executing commands inside standalone ad-hoc cli container

This allows you to define a global command that will execute in a standalone cli container spawned on demand.
It is like running `fin run-cli ...`.
This will allow you to create a command in node or php that would not actually require them to be installed locally.

In your script define:

```
#: exec_target = run-cli
```

## Grouping Commands

Docksal allows for commands to be grouped together within folders. This is particulary useful when creating a toolkit to share with other developers. Commands can be grouped within the Global Scope `~/.docksal/commands` and on a per project basis.

To view commands, run `fin help` and there should be similar output. This will show the available commands and prefix them within the folder they are located in.

```
Custom commands:
  site/init                 Initialize stack and site (full reset)
  drupal/updb [g]     	    Opens SequelPro
```

Commands are ran in the same exact way as normal except include the folder they are part of.

```
fin drupal/updb
```

## More examples

Check the commands directory (examples/.docksal/commands) located in the [Docksal project](https://github.com/docksal/docksal).
