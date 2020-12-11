---
title: "Launch a Project Stack"
weight: 2
aliases:
  - /en/master/getting-started/project-setup/
---

## "Projects" directory {#projects-directory}

Pick a directory where you will store all your (Docksal) projects.

On Mac and Linux, the recommended "Projects" directory is `~/Projects`.  
On Mac, the directory must be within `/Users`. There are no restrictions for Linux.

On Windows, the recommended "Projects" directory is `C:\Projects`.  
The directory must be within the Windows (and not WSL) filesystem (i.e., you cannot use `~/Projects` in WSL on Windows).  


## Launching your first Docksal stack

Whether you have an existing codebase or want to start from scratch, you can initialize a **dedicated** basic LAMP stack 
for a project/directory with a **single command**: 

```bash
fin init
```

Run the command within your ["Projects" directory](#projects-directory) and follow onscreen instructions.

```bash
$ mkdir -p ~/Projects/myproject
$ cd ~/Projects/myproject
$ fin init
Initialize a project in /Users/leonid/Work/Projects/myproject? [y/n]: y
DOCROOT has been detected as docroot. Is that correct? [y/n]: y
Configuration was generated. You can start it with fin project start
Starting services...
Creating network "myproject_default" with the default driver
Creating volume "myproject_cli_home" with default driver
Creating volume "myproject_project_root" with local driver
Creating volume "myproject_db_data" with default driver
Creating myproject_db_1  ... done
Creating myproject_cli_1 ... done
Creating myproject_web_1 ... done
Connected vhost-proxy to "myproject_default" network.
Waiting for project stack to become ready...
Project URL: http://myproject.docksal
```

Open `http://myproject.docksal` in your browser to verify the setup.

The directory name becomes the project name as well as the virtual host name.

{{% notice warning %}}
Only lowercase alphanumeric, underscore, and hyphen are allowed in the project/directory name.
{{% /notice %}}

{{% notice tip %}}
If your project does not use a sub-directory for the document root, then use `.` as the `DOCROOT` when asked by the wizard.      
{{% /notice %}}

{{% notice note %}}
If you see requests for the SSH key passphrase for `id_dsa` or `id_rsa`, those are the keys in your `~/.ssh` folder.  
SSH keys are automatically loaded into the **ssh-agent** container and can then be used by any Docksal project stack 
running on your machine. [Read more](/core/system-ssh-agent/) about the ssh-agent system service in Docksal.
{{% /notice %}}

Running `fin init` again will reset your project stack. See `fin help project` for the list of project level commands.

MySQL connection settings are injected via environment variables. You can access those via [getenv()](https://www.php.net/manual/en/function.getenv.php) in PHP.

```php
<?php

$host = getenv('MYSQL_HOST');
$user = getenv('MYSQL_USER');
$pass = getenv('MYSQL_PASSWORD');
$db   = getenv('MYSQL_DATABASE');

echo "mysql://$user:$pass@$host/$db";
```  


## Quick start using a boilerplate

You can start from a [boilerplate repo](https://github.com/docksal?q=boilerplate) using the wizard:

```bash
fin project create
```

Run the command within your ["Projects" directory](#projects-directory) and follow onscreen instructions.

```
$ fin project create
1. Name your project (lowercase alphanumeric, underscore, and hyphen): demo

2. What would you like to install?
  PHP based
    1.  Drupal 8
    2.  Drupal 8 (Composer Version)
    3.  Drupal 8 (BLT Version)
    4.  Drupal 7
    5.  Wordpress
    6.  Magento
    7.  Laravel
    8.  Symfony Skeleton
    9.  Symfony WebApp
    10. Grav CMS
    11. Backdrop CMS

  Go based
    12. Hugo

  JS based
    13. Gatsby JS
    14. Angular

  HTML
    15. Static HTML site
    
  Custom
    0.  Custom git repository
  ...

Enter your choice (0-15): 1

Project folder:   /Users/username/Projects/demo
Project software: Drupal 8
Source repo:      https://github.com/docksal/boilerplate-drupal8.git
Project URL:      http://demo.docksal

Do you wish to proceed? [y/n]: y
Cloning repository...
...

3. Passing execution to fin init...
...

Open http://demo.docksal in your browser to verify the setup.
 DONE!  Completed all initialization steps.
``` 

Open `http://demo.docksal` in your browser to verify the setup.


## Automating stack and project initialization

Site provisioning can be automated via a [custom command](/fin/custom-commands/).

Every Docksal powered project has at least one custom command - `fin init` (stored in `.docksal/commands/init`). 

The `init` command should facilitate project provisioning from zero to a **fully working application**. 
It should be used to automate project specific initialization tasks, like: 

- initialize stack configuration
- import databases or perform a site install
- run database updates, special commands, etc.
- build project dependencies (npm, etc.)
- run tests

It is recommended to break different steps into a dedicated [custom command](/fin/custom-commands/), then invoke 
them in the `init` command.

For a working example of a Docksal powered project with `fin init` take a look at:

- [Drupal 7](https://github.com/docksal/boilerplate-drupal7)
- [Drupal 8](https://github.com/docksal/boilerplate-drupal8)
- [WordPress](https://github.com/docksal/boilerplate-wordpress)
- [NodeJS](https://github.com/docksal/boilerplate-nodejs)
- [List of all boilerplate projects](https://github.com/docksal?q=boilerplate)

{{% notice note %}}
These are the repos used by the `fin project create` wizard.
{{% /notice %}}
