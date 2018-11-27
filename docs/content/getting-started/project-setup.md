---
title: "Project setup"
weight: 3
aliases:
  - /en/master/getting-started/project-setup/
---

## Configuring a project to use Docksal

With Docksal you can initialize a basic LAMP stack with no configuration.   
In this case a default configuration will be used to provision containers and set up a virtual host.

Initial configuration is done once per project (e.g., by a team lead) and committed to the project repo. 
Presence of the `.docksal` folder in the project directory is a good indication the project is using Docksal.


## Project directory structure

Create a project directory structure:

```bash
mkdir ~/projects/myproject
mkdir ~/projects/myproject/docroot
mkdir ~/projects/myproject/.docksal
```

The `docroot` directory is mounted as the web server document root.  
The `.docksal` directory is where all Docksal configurations and commands for the project are stored.

{{% notice tip %}}
Is your Project Root the same as your Document Root? If so, you can accomplish this by running `fin config set DOCROOT=.` which sets the value in the `.docksal/docksal.env` file.
{{% /notice %}}

## Start containers

```bash
cd ~/projects/myproject
fin project start
```

You will see output similar to the following:

```
Starting services...
Creating network "myproject_default" with the default driver
Creating volume "myproject_project_root" with local driver
Creating myproject_cli_1
Creating myproject_db_1
Creating myproject_web_1
Connected vhost-proxy to "myproject_default" network.
```

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

{{% notice tip %}}
By default, the virtual host name is equal to the project's folder name sans spaces (underscores are converted to hyphens)
with the `.docksal` domain appended to it.  
`myproject => myproject.docksal`
{{% /notice %}}
    
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

- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)
- [WordPress sample project](https://github.com/docksal/wordpress)
