# Docksal Fin

Docksal Fin (`fin`) is a command line tool for controlling a Docksal powered stack.  
`fin` runs natively on Mac and Linux. Windows users have to use [Babun](http://babun.github.io) shell to use `fin`.

## Using fin

To list available commands, either run `fin` with no parameters or execute `fin help`:

    $ fin help
    Docksal control cli utility v1.44.0

    Usage: fin <command>

    Management Commands:
      db <command>             	Manage databases (fin help db)
      project <command>        	Manage project(s) (fin help project)
      system <command>         	Manage Docksal (fin help system)
      vm <command>             	Manage Docksal VM (fin help vm)

    Commands:
      bash [service]           	Open shell into service's container. Defaults to cli
      logs [service]           	Show service logs (e.g. Apache logs, MySQL logs) and Unison logs (fin help logs)
      exec <command|file>      	Execute a command or a script in cli
      config [command]         	Show or generate configuration (fin help config)

      drush [command]          	Execute Drush command (Drupal)
      drupal [command]         	Execute Drupal Console command (Drupal 8)
      wp [command]             	Execute WP-CLI command (WordPress)

      addon <command>          	Addons management commands: install, remove (fin help addon)
      ssh-add [-lD] [key]      	Adds ssh private key to the authentication agent (fin help ssh-add)
      alias                    	Manage aliases that allow fin @alias execution (fin help alias)
      cleanup [--hard]         	Remove unused Docker images and projects (saves disk space)
      share                    	Create temporary public url for current project using ngrok
      exec-url <url>           	Download script from URL and run it on host (URL should be public)
      run-cli (rc) <command>   	Run a command in a standalone cli container in the current directory
      image <command>          	Image management commands: registry, save, load (fin help image)
      hosts <command>          	Hosts file commands: add, remove, list (fin help hosts)
      vhosts                   	List all virtual *.docksal hosts registered in docksal proxy
      sysinfo                  	Show system information for bug reporting
      diagnose                 	Show statistics for troubleshooting and bug reporting
      version (v, -v)          	Print fin version. [v, -v] prints short version
      update                   	Update Docksal

Some more complex management commands have their own help sections.

<a name="fin-help-db"></a>

    $ fin help db
    Database related commands
      fin db <command> [file] [options]	

    Commands:
      import [file] [options]  	Truncate the database and import from SQL dump file or stdin.
              --progress      	Show import progess (requires pv).
              --no-truncate   	Do no truncate database before import.
      dump [file]              	Dump a database into an SQL dump file or stdout.
      list (ls)                	Show list of existing databases.
      cli [query]              	Open command line interface to the DB server (and execute query if provided).
      create <name>            	Create a database.
      drop <name>              	Delete a database.

    Parameters:
      --db=drupal              	Use another database (default is the one set with 'MYSQL_DATABASE')
      --db-user=admin          	Use another mysql username (default is 'root')
      --db-password=p4$$       	Use another database password (default is the one set with 'MYSQL_ROOT_PASSWORD', see fin config)
      --db-charset=utf8        	Override charset when creating a database (default is utf8)
      --db-collation=utf8mb4   	Override collation when creating a database (default is utf8_general_ci)

    Examples:
      fin db import ~/dump.sql 			Import from dump.sql file
      fin db import ~/dump.sql --progress		Import from dump.sql file showing import progress
      fin db import ~/partial.sql --no-truncate	Import partial.sql without truncating DB

      cat dump.sql | fin db import			Import dump from stdin into default database
      zcat < dump.sql.gz | fin db import	        Import archived dump from stdin into default database
      fin db dump ~/dump.sql   			Export default database into dump.sql
      fin db dump --db=drupal  			Export database 'drupal' dump into stdout
      fin db dump --db=mysql --db-user=root --db-password=root mysql.sql    Export mysql database as root into mysql.sql	

      fin db cli --db=nondefault 'select * from users'    Execute query on database other than MYSQL_DATABASE	
      fin db create project2 --db-charset=utf8mb4    Create database project2 with utf8mb4 charset	

<a name="fin-help-project"></a>

    $ fin help project
    Project management
      fin project <command> [params]	

    Commands:
      start                    	Start project services (alias: fin start)
      up                       	Forces re-read of configuration and start project services (alias: fin up)
      stop [-a (--all)]        	Stop project services (-a stops all services on all projects) (alias: fin stop)
      status                   	List project services (alias: fin ps)
      restart                  	Restart project services (alias: fin restart)
      reset                    	Recreate project services and containers (fin help reset) (alias: fin reset)
      remove or rm             	Stop project services and remove their containers (fin help remove)
      config                   	Show project configuration
      build                    	Build or rebuild services (alias for 'docker-compose build')
      list [-a (--all)]        	List running Docksal projects (-a to show stopped as well) (alias: fin pl)
      create                   	Project wizard to create new Drupal, Wordpress, Magento or empty static project.

    Examples:
      fin pl -a                	List all known Docksal projects, including stopped ones
      fin project reset db     	Reset only DB service to start with DB from scratch
      fin project create       	Start a new project wizard

<a name="fin-help-system"></a>

    $ fin help system
    Manage Docksal
      fin system <command> [params]	

    Commands:
      reset                    	Reset Docksal
      start                    	Start Docksal
      stop                     	Stop Docksal
      status                   	Check Docksal status

    Examples:
      fin system reset         	Reset all Docksal system services and settings
      fin system reset dns     	Reset Docksal DNS service
      fin system reset vhost-proxy	Reset Docksal HTTP/HTTPS reverse proxy service (resolves *.docksal domain names into container IPs)
      fin system reset ssh-agent	Reset Docksal ssh-agent service

<a name="fin-help-vm"></a>

    $ fin help vm
    Control docker machine directly
      fin vm <command>         	

    Commands:
      start                    	Start the machine (create if needed)
      stop                     	Stop the machine
      kill                     	Forcibely stop the machine
      restart                  	Restart the machine
      status                   	Get the status
      ssh [command]            	Log into ssh or run a command via ssh
      remove                   	Remove Docksal machine and cleanup after it
      ip                       	Show the machine IP address
      ls                       	List all docker machines
      env                      	Display the commands to set up the shell for direct use of Docker client
      mount                    	Try remounting host filesystem (NFS on macOS, SMB on Windows)

      ram                      	Show memory size
      ram [megabytes]          	Set memory size. Default is 1024 (requires vm restart)
      hdd                      	Show disk size and usage
      stats                    	Show CPU and network usage

      regenerate-certs         	Regenerate TLS certificates and restart the VM

<a name="fin-help-image"></a>

    $ fin help image
    Image management
      fin image <command>      	

    Commands:
      registry                 	Show all Docksal images on Docker Hub
      registry [image name]    	Show all tags for a certain image

      save [--system|--project|--all]	Save docker images into a tar archive.
      load <file>              	Load docker images from a tar archive.

    Examples:
      fin image registry       	Show all available Docksal images on Docker Hub
      fin image registry docksal/db	Show all tags for docksal/db image
      fin image save --system  	Save Docksal system images.
      fin image save --project 	Save current project's images.
      fin image save --all     	Save all images available on the host.

<a name="fin-help-hosts"></a>

    $ fin help hosts
    Can add or remove lines to/from OS-dependent hosts file

      fin hosts [command]      	

      Uses 192.168.64.100 for IP when VirtualBox is used.	
      Uses 192.168.64.100 for IP when DOCKER_NATIVE is set.	

    Commands:
      add [hostname]           	Add hostname to hosts file. If no provided uses VIRTUAL_HOST
      remove [hostname]        	Remove all lines containing hostname from hosts file. Uses VIRTUAL_HOST if none provided
      list                     	Output hosts file
      <no command>             	Output hosts file
      help                     	Show this help

    Examples:
      fin hosts add            	Append current project's VIRTUAL_HOST to hosts file
      fin hosts add demo.docksal	Append a line '192.168.64.100 demo.docksal' to hosts file
      fin hosts remove         	Remove current project's VIRTUAL_HOST from hosts file
      fin hosts remove demo.docksal	Remove *all* lines containing demo.docksal from hosts file
      fin hosts                	Output hosts file

## Custom commands

Fin can be extended with project level [custom commands](../fin/custom-commands.md) written in any script language.

If a projects has custom commands defined, they will show up at the bottom of `fin help`:

    $ fin help
    ...
    Custom commands found in project commands:
        init                          Initialize a Docksal powered Drupal 8 site
