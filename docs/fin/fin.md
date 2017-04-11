# Docksal Fin

Docksal Fin (`fin`) is a command line tool for controlling a Docksal powered stack.  
`fin` runs natively on Mac and Linux. Windows users have to use [Babun](http://babun.github.io) shell to use `fin`.

## Using fin

To list available commands, either run `fin` with no parameters or execute `fin help`:

    $ fin help
    Docksal Fin v1.6.0 command reference	
    
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
    sqld [file]              	Dump the database into a file (fin help sqld)
    sqli [file]              	Truncate the database and import from sql dump (fin help sqli)
    
    image <command>          	Image management
      save, load, registry   	See fin help image for details
    
    project <command>        	Project management
      list, create           	See fin help project for details
    
    ssh-add [-lD] [key]      	Adds private key identities to the authentication agent (fin help ssh-add)
    cleanup [--hard]         	Remove unused docker images and projects that are no longer present
    
    config                   	Display/generate project configuration (fin help config)
    run-cli (rc) <command>   	Run a command in a standalone cli container in the current directory
    share                    	Share web server of the current project on the internet using ngrok
    sysinfo                  	Show diagnostics information for bug reporting
    alias                    	Create/remove folder aliases (fin help alias)
    version (v, -v)          	Print fin version. [v, -v] - prints short version
    update                   	Update Docksal

Some more complex management commands have their own help sections.

<a name="fin-help-vm"></a>

    $ fin help vm
    Control docker machine directly
      fin vm <command>         	
    
    Commands:
      start                    	Start a machine (create if needed)
      stop                     	Stop active machine
      kill                     	Forcibely stop active machine
      restart                  	Restart a machine
      status                   	Get the status of a machine
      ls                       	List all docker machines
      ssh                      	Log into or run a command on the active machine with SSH
      remove                   	Remove active machine
      ip                       	Get machine IP address
      env                      	Display the commands to set up the shell for direct use of Docker client
    
      mount                    	Try remounting host filesystem (NFS on macOS, SMB on Windows)
      ram                      	Get machine memory size
      ram [megabytes]          	Set machine memory size. Default is 1024 (requires vm restart)
      stats                    	Show machine HDD/RAM usage stats

<a name="fin-help-image"></a>

    $ fin help image
    Image management
      fin image <command>      	
    
      save [--system|--project|--all]	Save docker images into a tar archive.
      load <file>              	Load docker images from a tar archive.
    
      registry                 	Show all Docksal images on Docker Hub
      registry [image name]    	Show all tags for a certain image
    
    Examples:
      fin image save --system  	Save Docksal system images.
      fin image save --project 	Save current project's images.
      fin image save --all     	Save all images available on the host.
      fin image registry docksal/db	Show all tags for docksal/db image

<a name="fin-help-project"></a>

    $ fin help project
    Project management
      fin project <command>    	
    
      list (pl) [-a (--all)]   	List running Docksal projects (-a to show stopped as well)
      create                   	Create and install new Drupal, Wordpress or Magento project.
    
    Examples:
      fin pl -a                	List all known Docksal projects, including stopped ones

## Custom commands

Fin can be extended with project level [custom commands](../fin/custom-commands.md) written in any script language.

If a projects has custom commands defined, they will show up at the bottom of `fin help`:

    $ fin help
    ...
    Custom commands found in project commands:
        init                          Initialize a Docksal powered Drupal 8 site
