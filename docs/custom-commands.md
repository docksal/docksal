# DSH custom commands

Extending DSH with your custom commands is supported in DSH 1.17 and higher.

1. Create a custom command

    File `.drude/commands/updb` (Notice **no extension**. Script name should match command name)

    ```bash
    #!/bin/bash
    
    ## Runs drush updb
    ##
    ## Usage:	dsh updb [params to passthrough]
    
    dsh drush updb $1
    ```

2. Set executable bit: `chmod +x .drude/commands/updb`
3. Use as regular dsh command: `dsh updb`
4. Passing parameters also works: `dsh updb -y`
5. See command description in `dsh help` and command full help via `dsh help updb` 

## Available variables

These environment variables are available for use inside you custom command scripts:

* `DRUDE_PATH` - absolute path to `.drude` folder  
* `YML_PATH` - absolute path to `docker-compose.yml`. Usually equals DRUDE_PATH but can be empty is yml is not found.
* `DOCKER_RUNNING` - string values "true" and "false"

Example `init` command:  

```bash
#!/usr/bin/env bash

## Initialize site

if [ -z "$YML_PATH"]; then
	cp docker-compose.yml.dist docker-compose.yml
fi

# Start containers
dsh up
# Install site
dsh drush site-install -y --site-name="My Drupal site"
# Get login link
cd docroot 2>dev/null 
dsh drush uli
```

## Documenting custom command

dsh looks for lines starting with `##` for command documentation. 

```bash
## Custom command description
## Usage:	dsh mycommand [--force]
## Parameters:
## 		--force		Try really hard
```

dsh will output first line of custom command documentation as a short decription in `dsh help`.  
Rest of lines will be available as advanced help via `dsh help command_name`

See example of command documentation in [phpcs command](../examples/.drude/commands/phpcs)

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

[Custom command examples](../examples/.drude/commands)
