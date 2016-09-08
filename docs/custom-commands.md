# Fin custom commands

It is possible to extend fin with custom commands (per project).

1. Create a custom command

    File `.docksal/commands/updb` (Notice **no extension**. Script name should match command name)

    ```bash
    #!/bin/bash
    
    ## Runs drush updb
    ##
    ## Usage:	fin updb [params to passthrough]
    
    fin drush updb $1
    ```

2. Set executable bit: `chmod +x .docksal/commands/updb`
3. Use as regular fin command: `fin updb`
4. Passing parameters also works: `fin updb -y`
5. See command description in `fin help` and command full help via `fin help updb` 

## Available variables

These environment variables are available for use inside you custom command scripts:

* `PROJECT_ROOT` - absolute path to `.docksal` folder  
* `YML_PATH` - absolute path to `docker-compose.yml`. Usually equals PROJECT_ROOT but can be empty is yml is not found.
* `DOCKER_RUNNING` - string values "true" and "false"

Example `init` command:  

```bash
#!/usr/bin/env bash

## Initialize site

if [ -z "$YML_PATH"]; then
	cp docker-compose.yml.dist docker-compose.yml
fi

# Start containers
fin up
# Install site
fin drush site-install -y --site-name="My Drupal site"
# Get login link
cd docroot 2>dev/null 
fin drush uli
```

## Documenting custom command

fin looks for lines starting with `##` for command documentation. 

```bash
## Custom command description
## Usage:	fin mycommand [--force]
## Parameters:
## 		--force		Try really hard
```

fin will output first line of custom command documentation as a short decription in `fin help`.  
Rest of lines will be available as advanced help via `fin help command_name`

See example of command documentation in [phpcs command](../examples/.docksal/commands/phpcs)

## Global custom commands

Put your command to `~/.docksal/commands` and it will be accessible globally.  
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

[Custom command examples](../examples/.docksal/commands)
