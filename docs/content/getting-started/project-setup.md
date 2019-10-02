---
title: "Project Setup"
weight: 2
aliases:
  - /en/master/getting-started/project-setup/
---

## Launching your first Docksal project

To make sure Docksal has been installed properly, you can use the boilerplate project wizard.

Run the following command within your designated "Projects" directory and follow onscreen instructions:

```bash
fin project create
``` 

{{% notice note %}}
For Mac and Linux users, the recommended designated "Projects" directory is `~/Projects`.

For Windows users, this directory **must** be within the Windows (not WSL) filesystem.
This means that you cannot use `~/Projects` in WSL on Windows and use something like `/c/Projects` instead.  
{{% /notice %}}

The wizard clones one of the boilerplate Docksal project repos from GitHub and runs `fin init`.

`fin init` is a single command used to bootstrap a project from zero to a fully working application. 

Confirming that a boilerplate project stack works helps verify that your Docksal installation functions properly.  


## Configuring Docksal for an existing codebase

The initial configuration is done once per project (e.g., by a team lead) and committed to the project repo. 
Presence of the `.docksal` folder in the project directory is a good indication the project is already using Docksal.

To configure Docksal for an existing project, run the following command within the project's root directory 
and follow onscreen instructions:

```bash
fin init
```

This will initialize Docksal settings in the project's codebase and start a dedicated default LAMP stack for your project.

You will see output similar to the following:

```
$ fin init
Initialize a project in /path/to/Projects/myproject? [y/n]: y
DOCROOT has been detected as docroot. Is that correct? [y/n]: y
Configuration was generated. You can start it with fin project start
Key 'id_ecdsa' already loaded in the agent. Skipping.
Key 'id_rsa' already loaded in the agent. Skipping.
Starting services...
Creating network "myproject_default" with the default driver
Creating volume "myproject_cli_home" with default driver
Creating volume "myproject_project_root" with local driver
Creating volume "myproject_db_data" with default driver
Creating myproject_cli_1 ... done
Creating myproject_db_1  ... done
Creating myproject_web_1 ... done
Connected vhost-proxy to "myproject_default" network.
Waiting for project stack to become ready...
Waiting for project stack to become ready...
Project URL: http://myproject.docksal
```

{{% notice tip %}}
If you project root is the web document root, then use `.` as the `DOCROOT` when asked by the wizard.      
{{% /notice %}}

{{% notice note %}}
**Note: SSH key passphrase** 
If you are being asked for an SSH key passphrase for `id_dsa` or `id_rsa`, 
remember, that these are **your** keys loaded from your `~/.ssh` folder into the `ssh-agent` container.  
That's why their paths look like `/root/.ssh/...`. That is the path **inside the ssh-agent container**.  
Provide password(s) if you want to use git or drush commands, that require ssh access within Docksal 
(e.g., often a project init script or a composer script contains a repository checkout, 
which would require an ssh key for access).
{{% /notice %}}

## Your project is ready

Your project stack is now running. Access it in your browser: `http://myproject.docksal`

{{% notice note %}}
By default, the virtual host name is equal to the project's folder name sans spaces (underscores are converted to hyphens)
with the `.docksal` domain appended to it.  
`myproject => myproject.docksal`
{{% /notice %}}

{{% notice warning %}} Project paths that include spaces will cause errors where the project may not be recongnized as unique, e.g., `/Users/username/Development/Company Projects/project`. Removing spaces from path directories with prevent these errors. {{% /notice %}}
    
## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](/fin/custom-commands/) (e.g., `fin init`, which will call `.docksal/commands/init`). Put project specific initialization tasks there, like:

- initialize the Docksal configuration
- import databases or perform a site install
- compile SASS
- run DB updates, special commands, etc.
- run Behat tests

### Sample projects

For a working example of a Docksal powered project with `fin init` take a look at:

- [Drupal 7 sample project](https://github.com/docksal/boilerplate-drupal7)
- [Drupal 8 sample project](https://github.com/docksal/boilerplate-drupal8)
- [WordPress sample project](https://github.com/docksal/boilerplate-wordpress)
