# Docksal Fin

Docksal Fin (`fin`) is a command line tool for controlling a Docksal powered stack.  
`fin` runs natively on Mac and Linux. Windows users have to use [Babun](http://babun.github.io) shell to use `fin`.

## Using fin

To list available commands, either run `fin` with no parameters or execute `fin help`:

    $ fin
    Docksal Fin v1.2.0 command reference

    start (up)               	Start project services
    stop [-a (--all)]        	Stop project services (-a stops all services on all projects)
    restart                  	Restart project services
    reset                    	Recreate project services and containers (fin help reset)
    remove (rm)              	Stop project services and remove their containers (fin help remove)
    status (ps)              	List project services

    vm <command>             	Docksal's Virtualbox machine commands (fin help vm)
      start, stop, restart, status, ls, ssh, remove, ip, env, ram, stats

    bash [service]           	Open shell into service's container. Defaults to cli
    exec <command|file>      	Execute a command or a file in cli
    exec-url <url>           	Download script from URL and run it on host (URL should be public)
    logs [service]           	Show Docker logs for service container (e.g. Apache logs)

    drush [command]          	Execute Drush command (Drupal)
    drupal [command]         	Execute Drupal Console command (Drupal 8)
    wp [command]             	Execute WP-CLI command (WordPress)

    sqlc                     	Opens mysql shell to current project database (fin help sqlc)
    sqls                     	Show list of available databases (fin help sqls)
    sqld [file]              	Dump specified database into file (fin help sqld)
    sqli [file]              	Truncate database and import from sql dump (fin help sqli)

    project <command>        	Project management
      list, create           	See fin help project for details

    ssh-add [-lD] [key]      	Adds private key identities to the authentication agent (fin help ssh-add)
    cleanup [--hard]         	Remove unused docker images and projects that are no longer present

    config                   	Display/generate project configuration (fin help config)
    share                    	Share web server of the current project on the internet using ngrok
    sysinfo                  	Show diagnostics information for bug reporting
    alias                    	Create/remove folder aliases (fin help alias)
    version (v, -v)          	Print fin version. [v, -v] - prints short version
    update                   	Update Docksal


## Custom commands

Fin can be extended with project level [custom commands](../fin/custom-commands.md) written in any script language.

If a projects has custom commands defined, they will show up at the bottom of `fin help`:

    $ fin help
    ...
    Custom commands found in project commands:
        init                          Initialize a Docksal powered Drupal 8 site
