# Docksal Fin

Docksal Fin (`fin`) is a command line tool for controlling a Docksal powered stack.  
`fin` runs natively on Mac and Linux. Windows users have to use [Babun](http://babun.github.io) shell to use `fin`.

## Using fin

To list available commands, either run `fin` with no parameters or execute `fin help`:

    $ fin help
    Docksal Fin v1.9.0 commands:	
    start (up)               	Start project services
    stop [-a (--all)]        	Stop project services (-a stops all services on all projects)
    restart                  	Restart project services
    reset                    	Recreate project services and containers (fin help reset)
    remove (rm)              	Stop project services and remove their containers (fin help remove)
    status (ps)              	List project services
    logs [service]           	Show service logs (e.g. Apache logs, MySQL logs)
    config [command]         	Show project configuration (See fin help config for generate)

    db <command>             	DB commands: import, dump, list, cli (fin help db)
    project <command>        	Projects management commands: list, create (fin help project)
    vm <command>             	VM commands: start, stop, restart and more. See fin help vm

    bash [service]           	Open shell into service's container. Defaults to cli
    exec <command|file>      	Execute a command or a script in cli
    ssh-add [-lD] [key]      	Adds ssh private key to the authentication agent (fin help ssh-add)

    drush [command]          	Execute Drush command (Drupal)
    drupal [command]         	Execute Drupal Console command (Drupal 8)
    wp [command]             	Execute WP-CLI command (WordPress)

    share                    	Create temporary public url for current project using ngrok
    alias                    	Manage aliases that allow fin @alias execution (fin help alias)
    exec-url <url>           	Download script from URL and run it on host (URL should be public)
    run-cli (rc) <command>   	Run a command in a standalone cli container in the current directory
    image <command>          	Image management commands: registry, save, load (fin help image)
    cleanup [--hard]         	Remove unused Docker images and projects (saves disk space)
    hosts [command]          	Hosts file commands: add, remove, list (fin help hosts)
    sysinfo                  	Show diagnostics information for bug reporting
    version (v, -v)          	Print fin version. [v, -v] prints short version
    update                   	Update Docksal

Some more complex management commands have their own help sections.

<a name="fin-help-db"></a>

    $ fin help db
    Database related commands
      fin db <command>          

    Commands:
      import [file]             Truncate the database and import from sql dump file or stdin
      dump [file]               Dump the database into a file or stdout
      list (ls)                 Show list of available databases
      cli                       Opens command line interface to MySQL server

    Parameters:
      --db=drupal               Use another database (default is the one set with 'MYSQL_DATABASE')
      --db-user=admin           Use another mysql username (default is 'root')
      --db-password=p4$$        Use another database password (default is the one set with 'MYSQL_ROOT_PASSWORD', see fin config)

    Examples:
      fin db import ~/dump.sql  Import from dump.sql file
      cat dump.sql | fin db import  Import dump from stdin into default database
      fin db dump ~/dump.sql    Export default database into dump.sql
      fin db dump --db=drupal   Export database 'drupal' dump into stdout
      fin db                    Opens command line interface
      fin db ls                 List databases
      fin db dump --db=mysql --db-user=root --db-password=root mysql.sql    Export mysql database as root into mysql.sql

<a name="fin-help-project"></a>

    $ fin help project
    Project management
      fin project <command>     

    Commands:
      list (pl) [-a (--all)]    List running Docksal projects (-a to show stopped as well)
      create                    Create and install new Drupal, Wordpress or Magento project.

    Examples:
      fin pl -a                 List all known Docksal projects, including stopped ones
      fin project create        Start project wizard


<a name="fin-help-vm"></a>

    $ fin help vm
    Control docker machine directly
      fin vm <command>          

    Commands:
      start                     Start the machine (create if needed)
      stop                      Stop the machine
      kill                      Forcibely stop the machine
      restart                   Restart the machine
      status                    Get the status
      ssh [command]             Log into ssh or run a command via ssh
      remove                    Remove Docksal machine and cleanup after it
      ip                        Show the machine IP address
      ls                        List all docker machines
      env                       Display the commands to set up the shell for direct use of Docker client
      mount                     Try remounting host filesystem (NFS on macOS, SMB on Windows)

      ram                       Show memory size
      ram [megabytes]           Set memory size. Default is 1024 (requires vm restart)
      hdd                       Show disk size and usage
      stats                     Show CPU and network usage

<a name="fin-help-image"></a>

    $ fin help image
    Image management
      fin image <command>       

    Commands:
      registry                  Show all Docksal images on Docker Hub
      registry [image name]     Show all tags for a certain image

      save [--system|--project|--all] Save docker images into a tar archive.
      load <file>               Load docker images from a tar archive.

    Examples:
      fin image registry        Show all available Docksal images on Docker Hub
      fin image registry docksal/db Show all tags for docksal/db image
      fin image save --system   Save Docksal system images.
      fin image save --project  Save current project's images.
      fin image save --all      Save all images available on the host.

<a name="fin-help-hosts"></a>

    $ fin help hosts
    Can add or remove lines to/from OS-dependent hosts file

      fin hosts [command]       

      Uses 192.168.64.100 for IP when VirtualBox is used. 
      Uses 192.168.64.100 for IP when DOCKER_NATIVE is set. 

    Commands:
      add [hostname]            Add hostname to hosts file. If no provided uses VIRTUAL_HOST
      remove [hostname]         Remove all lines containing hostname from hosts file. Uses VIRTUAL_HOST if none provided
      list                      Output hosts file
      <no command>              Output hosts file
      help                      Show this help

    Examples:
      fin hosts add             Append current project's VIRTUAL_HOST to hosts file
      fin hosts add demo.docksal  Append a line '192.168.64.100 demo.docksal' to hosts file
      fin hosts remove          Remove current project's VIRTUAL_HOST from hosts file
      fin hosts remove demo.docksal Remove *all* lines containing demo.docksal from hosts file
      fin hosts                 Output hosts file

## Custom commands

Fin can be extended with project level [custom commands](../fin/custom-commands.md) written in any script language.

If a projects has custom commands defined, they will show up at the bottom of `fin help`:

    $ fin help
    ...
    Custom commands found in project commands:
        init                          Initialize a Docksal powered Drupal 8 site
