---
title: "fin help"
weight: 2
aliases:
  - /en/master/fin/fin-help/
---

## fin {#fin}

	Docksal command line utility (v1.107.1)
	Docksal docs: https://docs.docksal.io/
	
	Usage: fin [command]
	
	Management Commands:
	  db <command>             	Manage databases (fin help db)
	  project <command>        	Manage project(s) (fin help project)
	  ssh-key <command>        	Manage SSH keys (fin help ssh-key)
	  system <command>         	Manage Docksal state (fin help system)
	  vm <command>             	Manage Docksal VM (fin help vm)
	
	Commands:
	  bash [service]           	Open shell into service's container. Defaults to cli
	  logs [service]           	Show service logs (e.g., Apache logs, MySQL logs) and Unison logs (fin help logs)
	  exec <command|file>      	Execute a command or a script in cli
	  config [command]         	Show or change configuration (fin help config)
	  run-cli (rc) <command>   	Run a command in a standalone cli container in the current directory (fin help run-cli)
	
	  pull [options]           	Commands for interacting with Hosting Provider (fin help pull)
	  drush [command]          	Drush command (requires Drupal)
	  drupal [command]         	Drupal Console command (requires Drupal 8)
	  platform [command]       	Platform.sh's CLI (requires docksal/cli 2.3+)
	  terminus [command]       	Pantheon's Terminus (requires docksal/cli 2.1+)
	  wp [command]             	WordPress CLI command (requires WordPress)
	  composer [command]       	Run Composer commands
	  docker (d) [command]     	Run Docker commands directly
	  docker-compose (dc) [cmd]	Run Docker Compose commands directly
	
	  init                     	Initialize a project (override it with your own automation, see fin help init)
	  addon <command>          	Addons management commands: install, remove (fin help addon)
	  alias                    	Manage aliases that allow fin @alias execution (fin help alias)
	  cleanup [options]        	Remove all unused Docker images, unused Docksal volumes and containers
	  share                    	Create temporary public url for current project using ngrok
	  exec-url <url>           	Download script from URL and run it on host (URL should be public)
	  image <command>          	Image management commands: registry, save, load (fin help image)
	  hosts <command>          	Hosts file commands: add, remove, list (fin help hosts)
	  vhosts                   	List all virtual *.docksal hosts registered in Docksal proxy
	  sysinfo                  	Show system information
	  diagnose                 	Show diagnostic information for troubleshooting and bug reporting
	  version (--version, v, -v)	Print fin version. [v, -v] prints short version
	  update                   	Update Docksal

## project {#project}

	
	Project management
	
	Usage: project <command> [params]
	
	Commands:
	  start                    	Start project services (alias: fin start)
	  up                       	Configuration re-read and start project services (alias: fin up)
	  stop [option] [service]  	Stop all or specified project services (alias: fin stop)
	    --all (-a)             	Stop all services on all Docksal projects
	
	  status                   	List project services (alias: fin ps)
	  restart                  	Restart project services (alias: fin restart)
	  reset [service]          	Recreate all or specified project services, their containers and volumes
	
	  remove [option] [service]	Remove all project services, networks and all their volumes, or specified services only
	      rm [option] [service]	
	    --force (-f)           	Do not ask for confirmation when deleting all project services
	
	  list [option]            	List running Docksal projects (alias: fin pl)
	    --all (-a)             	List all Docksal projects (stopped as well)
	
	  create [options]         	Create a new project with a pre-configured boilerplate:
	                           	Drupal, Wordpress, Magento, Laravel, Backdrop, Hugo, Gatsby, and others
	    --name=name            	Provide project name upfront
	    --choice=#             	Provide software choice number upfront
	    --repo=name            	Clone from a custom repo: name (--choice is set to '0' automatically)
	    --branch=name          	Clone from a custom repo: branch name (optional)
	    --yes (-y)             	Avoid confirmation
	
	  config                   	Show project configuration
	  build                    	Build or rebuild services (alias for 'docker-compose build')
	
	Examples:
	  fin pl -a                	List all known Docksal projects, including stopped ones
	  fin project reset db     	Reset only DB service to start with DB from scratch
	  fin project create       	Start a new project wizard
	  fin project create --name=myproject --repo=https://github.com/org/project.git	
	                           	Initialize project from a custom git repo

## db {#db}

	
	Database management commands
	
	Usage: db <command> [file] [options]
	
	Commands:
	  import [file] [options]  	Truncate the database and import from SQL dump file or stdin.
	           --progress      	Show import progess (requires pv).
	           --no-truncate   	Do no truncate database before import.
	  dump [file]              	Dump a database into an SQL dump file or stdout.
	  list (ls)                	Show list of existing databases.
	  cli [query]              	Open command line interface to the DB server (and execute query if provided).
	  create <name>            	Create a database.
	  drop <name>              	Delete a database.
	  truncate [name]          	Truncate a database (defaults to the `default`)
	
	Options:
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
	  zcat < dump.sql.gz | fin db import		Import archived dump from stdin into default database
	  fin db dump ~/dump.sql   			Export default database into dump.sql
	  fin db dump --db=drupal  			Export database 'drupal' dump into stdout
	  fin db dump --db=mysql --db-user=root --db-password=root mysql.sql    Export mysql database as root into mysql.sql	
	
	  fin db cli --db=nondefault 'select * from users'    Execute query on database other than MYSQL_DATABASE	
	  fin db create project2 --db-charset=utf8mb4    Create database project2 with utf8mb4 charset	

## pull {#pull}

	
	Docksal Provider Interaction commands.
	
	Usage: pull <options> <asset>
	
	Possible Options for Asssets:
	  init                     	Pull a project repo down
	  db                       	Export a database from the provider
	  files                    	Rsync files from remote to local
	  code                     	Execute a pull on code
	  (blank)                  	All (Default)
	
	Options:
	  --hosting-platform=<provider>	Platform to interact with.
	                           	Options: acquia, pantheon, platform.sh, drush, wp
	  --hosting-site=<id>      	Site ID on Provider
	  --hosting-env=<env>      	Site Env on Provider
	
	Extra Options for Code
	  --sync-git-remote        	The GIT Remote to pull from. (Defaults to origin)
	  --sync-git-branch        	The GIT Branch to pull from. (Defaults to current branch)
	
	Extra Options for DB
	  --db-user=<user>         	Specify the DB User (Defaults to root)
	  --db-pass=<pass>         	Specify the DB Password (Defaults to root)
	  --db-name=<dbname>       	Specify the DB Name to import into. (Defaults to default)
	  --force                  	Generate and pull a new db dump, rather than using locally cached in /tmp
	  --remote-db=<remotedb>   	Specify the remote DB name to pull. (Used with Acquia)
	
	Extra Options for Files
	  --rsync-options=<options>	Rsync Options to append.
	  --files-dir=<dir>        	Directory to sync files with.
	                           	Default Drupal: {DOCROOT}/sites/default/files/
	                           	Wordpress Default: {DOCROOT}/wp-content/uploads/
	
	Examples:
	  fin pull init            	Start a project by pulling the repo from the provider.
	      --hosting-platform=acquia	Provide the Platform Name.
	      --hosting-site=testsiteid	Provide the Site ID.
	      test_project_directory	Specify the directory to clone the project in.
	  fin pull                 	Pull all items from provider
	  fin pull db              	Pull only the db from the provider
	  fin pull db --remote-db=dbname	Pull the db name dbname from the provider. (Acquia Cloud Only)

## ssh-key {#ssh-key}

	
	Manage SSH keys loaded into Docksal
	
	  Private SSH keys loaded into the secure docksal-ssh-agent service are accessible to all project containers.	
	  This allows containers to connect to the external SSH servers that require SSH keys	
	  without a need to copy over the key into the container every time.	
	  Default keys id_rsa/id_dsa/id_ecdsa/id_ed25519 are loaded automatically on every project start.	
	
	Usage: fin ssh-key <command> [params]
	
	Commands:
	  add [key-name] [--quiet] 	Add a private SSH key from $HOME/.ssh by file name
	                           	Adds all default keys (id_rsa/id_dsa/id_ecdsa/id_ed25519) if no file name is given.
	                           	Suppress key already loaded notifications if --quiet option specified.
	  ls                       	List SSH keys loaded in the docksal-ssh-agent
	  rm                       	Remove all keys from the docksal-ssh-agent
	  new [key-name]           	Generate a new SSH key pair
	
	Examples:
	  fin ssh-key add          	Loads all SSH keys with default names: id_rsa/id_dsa/id_ecdsa from $HOME/.ssh/
	  fin ssh-key add server_rsa	Loads the key stored in $HOME/.ssh/server_id_rsa into the agent
	  fin ssh-key new server2_rsa	Generates a new SSH key pair in ~/.ssh/server2_id_rsa

## system {#system}

	
	Manage Docksal system status (Docker should be running)
	
	Usage: system <command> [params]
	
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

## config {#config}

	
	Display, generate, or change project configuration
	
	Usage: config [command]
	
	Commands:
	  show [options]           	Display configuration for the current project
	      --show-secrets       	Do not truncate value of SECRET_* environment vars
	  env                      	Display only environment variables section
	  yml                      	Display static YML project config suitable for export (NOTE: SECRET_* values will not be hidden)
	
	  generate [options]       	Generate empty Docksal configuration for the project
	      --stack=acquia       	Set non-default DOCKSAL_STACK during config generate
	      --docroot=mydir      	Set non-default DOCROOT during config generate
	
	  set [options] [VAR=VAL]  	Set value(s) for the variable(s) in project ENV file
	      --global             	Set for global ENV file
	      --env=[name]         	Set in environment specific project ENV file
	
	  remove [options] [VAR]   	Remove variable(s) from project ENV file
	  rm [options] [VAR]       	
	      --global             	Remove from global ENV file
	      --env=[name]         	Remove from environment specific project ENV file
	
	  get [options] [VAR]      	Get the value of the single variable from project ENV file
	      --global             	Get value from global ENV file
	      --env=[name]         	Get value from environment specific project ENV file
	
	Examples:
	  fin config set DOCKER_NATIVE=1 --global	Adds DOCKER_NATIVE=1 into $HOME/.docksal/docksal.env
	  fin config rm DOCKER_NATIVE --global		Removes DOCKER_NATIVE value from $HOME/.docksal/docksal.env
	  fin config set DOCKSAL_STACK=acquia		Set different default stack in .docksal/docksal.env
	  fin config set --env=local XDEBUG_ENABLED=1	Enable XDEBUG in .docksal/docksal-local.env

## addon {#addon}

	
	Docksal Addons management commands.
	See available addons in the Addons Repository https://github.com/docksal/addons
	
	Usage: addon <command> <name>
	
	Commands:
	  install <name>           	Install addon
	  remove <name>            	Remove addon
	
	Examples:
	  fin addon install solr   	Install solr addon to the current project
	  fin addon remove solr    	Uninstall solr addon from the current project

## exec {#exec}

	
	Execute commands or script in `cli` service container,
	or execute commands in other containers when specified in params.
	fin exec will automatically cd into the same folder inside `cli`.
	
	Usage: exec [-T] [--in=name] <command | file>
	  [!] Parameters order matters.
	
	Options:
	  -T                       	Disable pseudo-tty allocation.
	                           	Useful for non-interactive commands when output is saved into a variable for further comparison.
	                           	In a TTY mode the output may contain unexpected invisible control symbols.
	  --in=name                	Name of the service or container to execute the command in.
	
	Examples:
	  fin exec ls -la          			Current directory listing
	  fin exec "ls -la > /tmp/list"			Execute advanced shell command with pipes or stdout redirects happening inside `cli`
	  res=$(fin exec -T drush st)			Use -T switch when using exec output
	  fin exec .docksal/script.sh			Execute a whole file inside `cli` container
	  fin exec --in=db mysql -uroot -p		Execute command in `db` container (will NOT cd into the same folder)

## run-cli {#run-cli}

	
	Runs commands in a standalone `cli` container mapped to the current directory.
	Container has a persistent $HOME directory where something can be saved in between launches.
	NOTE: `fin cleanup` will clean the persistent $HOME directory
	
	Usage: run-cli [options] <command>
	       rc [options] <command>
	
	Options:
	  --clean                  	Run command with a non-persistent $HOME directory
	  --cleanup                	Clean the persistent $HOME directory and run command
	  --debug                  	Print container debug output
	  --image=IMAGE            	Override default container image
	  -e VAR=VALUE             	Pass environment variable(s) to the container
	  -T                       	Disable pseudo-tty allocation (useful to get clean stdout)
	
	Examples:
	  fin rc ls -la            				Current directory listing
	  fin rc "ls -la > /tmp/list"				Execute advanced shell command with pipes or stdout redirects happening inside cli
	  fin rc -e VAR1=hello -e VAR2=world 'echo $VAR1 $VAR2'	Print hello world using ENV variables

## hosts {#hosts}

	
	Add or remove lines to/from OS-dependent hosts file (e.g., /etc/hosts)
	
	Usage: hosts [command]
	
	Commands:
	  add [hostname]           	Add hostname to hosts file. If none provided uses VIRTUAL_HOST
	  remove [hostname]        	Remove lines containing hostname from hosts file. If none provided uses VIRTUAL_HOST
	  list                     	Output hosts file
	
	Examples:
	  fin hosts add            	Append current project's VIRTUAL_HOST to hosts file
	  fin hosts add demo.docksal	Append a line '192.168.64.100 demo.docksal' to hosts file
	  fin hosts remove         	Remove current project's VIRTUAL_HOST from hosts file
	  fin hosts remove demo.docksal	Remove *all* lines containing demo.docksal from hosts file
	  fin hosts                	Output hosts file

## alias {#alias}

	
	Create, update, or delete project aliases.
	Aliases provide functionality that is similar to drush aliases.
	With alias you are able to execute a command in a project without navigating to the project folder.
	You can precede any command with an alias.
	Aliases are effectively symlinks stored in $HOME/.docksal/alias
	
	Usage: alias <command or path> [alias_name]
	
	Commands:
	  list                     	Show aliases list
	  <path> <alias_name>      	Create/update alias with <alias_name> that links to <path>
	  remove <alias_name>      	Remove alias
	
	Examples:
	  fin alias ~/site1/docroot dev		Create or update an alias dev that is linked to ~/site1/docroot
	  fin @project1 drush st   		Execute `drush st` command in directory linked by project1 alias
	                           		Hint: create alias linking to Drupal sub-site to launch targeted commands
	  fin alias remove project1		Delete project1 alias

## logs {#logs}

	
	View output from containers.
	
	Usage: logs [options] [--] [SERVICE...]
	
	Options:
	    --no-color              Produce monochrome output.
	    -f, --follow            Follow log output.
	    -t, --timestamps        Show timestamps.
	    --tail="all"            Number of lines to show from the end of the logs
	                            for each container.
	    --no-log-prefix         Don't print prefix in logs.
	
	Examples:
	  fin logs web             	Show web container logs
	  fin logs -f web          	Show web container logs and follow it

## image {#image}

	
	Docksal images listing and saving
	
	Usage: image <command>
	
	Commands:
	  registry                 	Show all Docksal images on Docker Hub
	  registry [image name]    	Show all tags for a certain image
	  save --system,--project,--all	Save docker images into a tar archive.
	  load <file>              	Load docker images from a tar archive.
	
	Examples:
	  fin image registry       	Show all available Docksal images on Docker Hub
	  fin image registry docksal/db	Show all tags for docksal/db image
	  fin image save --system  	Save Docksal system images.
	  fin image save --project 	Save current project's images.
	  fin image save --all     	Save all images available on the host.

