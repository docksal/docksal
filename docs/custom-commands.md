# Fin custom commands

It is possible to extend fin with custom commands per project or per host.

## Creating custom commands in a project 

Create a file at this location `.docksal/commands/updb` (Notice **no extension**. Script name should match command name) with the following contents:

```bash
#!/bin/bash

## Runs drush updb
##
## Usage: fin updb [params to passthrough]

fin drush updb $1
```

Make the file executable

```bash
chmod +x .docksal/commands/updb
```

Now you can use it as if it was a regular fin command: `fin updb`. 
Passing parameters also works: `fin updb -y`. 
The command description will be visible in `fin help` and the full command help will be available via `fin help updb`. 

Note: `drush updb` this is a Drupal-specific example.

## Available variables

These variables, provided by fin, are available for use inside you custom command scripts:

* `PROJECT_ROOT` - absolute path to the project folder.  
* `DOCROOT` - name of the docroot folder.
* `VIRTUAL_HOST` - the virtual host name for the project. For example, `projectname.docksal`.
* `DOCKER_RUNNING` - (string) "true" or "false".


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

Put your command in `~/.docksal/commands` and it will be accessible globally.  
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

## More examples

Check the commands directory (examples/.docksal/commands) located in the [Docksal project](https://github.com/docksal/docksal).
