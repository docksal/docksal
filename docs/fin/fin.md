# Docksal Fin

Docksal Fin (`fin`) is a command line tool for controlling a Docksal powered stack.  
`fin` runs natively on Mac and Linux. Windows users have to use [Babun](http://babun.github.io) shell to use `fin`.

## Using fin

To list available commands, either run `fin` with no parameters or execute `fin help`:

    $ fin
    Docksal Fin v0.18.2 command reference

    vm <command>                  Docksal's Virtualbox machine commands (fin help vm)

    start (up)                    Start virtualbox machine and project services
    stop [-a (--all)]             Stop project services (-a stops all services on all projects)
    restart                       Restart all current project services
    ps                            List project services
    reset [service]               Recreate project services and containers (fin help reset)
    rm [service]                  Remove project services (fin help rm)

    bash [service]                Open shell into container. Defaults to cli
    exec <command> [params]       Execute a command in cli
    exec-url <url>                Download script from URL and run it on host (URL should be public)
    logs [service]                Show Docker logs for service container (e.g. Apache logs)

    create-site                   Download and install Drupal or Wordpress.
    drush [command]               Execute Drush command (Drupal)
    drupal [command]              Execute Drupal Console command (Drupal 8)
    wp [command]                  Execute WP-CLI command (WordPress)

    sqlc                          Opens mysql shell to current project database (fin help sqlc)
    sqls                          Show list of available databases (fin help sqls)
    sqld [file]                   Dump specified database into file (fin help sqld)
    sqli [file]                   Truncate database and import from sql dump (fin help sqli)

    behat [--path=path]           Run Behat tests from path relative to YML path. Default: tests/behat
    ssh-add [-lD] [key]           Adds private key identities to the authentication agent (fin help ssh-add)

    alias                         Create/remove folder aliases (fin help alias)
    projects [-a (--all)]         List running Docksal projects (-a to show stopped as well)
    config [command]              Display/generate project configuration (fin help config)
    cleanup [--hard]              Remove unused docker images (--hard will also remove stopped containers)
    sysinfo                       Show diagnostics information for bug reporting
    share                         Share web server of the current project on the internet using ngrok
    version	(v, -v)               Print fin version. [v, -v] - prints short version
    update                        Update Docksal


## Custom commands

Fin can be extended with project level [custom commands](custom-commands.md) written in any script language.

If a projects has custom commands defined, they will show up at the bottom of `fin help`:

    $ fin help
    ...
    Custom commands found in project commands:
        init                          Initialize a Docksal powered Drupal 8 site
