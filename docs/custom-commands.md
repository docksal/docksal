# Fin custom commands

It is possible to extend fin with custom commands (per project).

1. Create a custom command

    File `.docksal/commands/updb` (Notice **no extension**. Script name should match command name)

    ```bash
    #!/bin/bash
    
    ## Runs drush updb
    ##
    ## Usage: fin updb [params to passthrough]
 
    fin drush updb $1
    ```

2. Make it executable
    ```
    chmod +x .docksal/commands/updb
    ```

Now you can use it as if it was a regular fin command: `fin updb`. Passing parameters also works: `fin updb -y`. Command description will be visible in `fin help` and command full help will be available via `fin help updb` 

## Available variables

These variables provided by fin are available for use inside you custom command scripts:

* `PROJECT_ROOT` - absolute path to the project folder.  
* `DOCROOT` - name of the docroot folder.
* `VIRTUAL_HOST` - for example `projectname.docksal`.
* `DOCKER_RUNNING` - (string) "true" or "false"


Example `init` command for a Drupal website using drush to automate the install:  

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

Fin will output first line of custom command documentation as a short decription in `fin help`.  
Rest of lines will be available as advanced help via `fin help command_name`

See an example of command documentation in the phpcs command (examples/.docksal/commands/phpcs located in the [Docksal project](https://github.com/docksal/docksal).)

## Global custom commands

Put your command in `~/.docksal/commands` and it will be accessible globally.  
Useful for tedious tasks that you need in every project.

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
