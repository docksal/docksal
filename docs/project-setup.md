# Configure a project to use Docksal

With Docksal you can initialize a basic LAMP stack with no configuration.   
In this case a default configuration will be used to provision containers and set up a virtual host.

Initial configuration is done once per project (e.g. by a team lead) and committed to the project repo. 
Presence of the `.docksal` folder in the project directory is a good indication the project is using Docksal.


## 1. Create a directory structure for the project

```bash
mkdir ~/projects/myproject
mkdir ~/projects/myproject/docroot
mkdir ~/projects/myproject/.docksal
```

The `docroot` directory is mounted as the web server document root.  
The `.docksal` directory is where all Docksal configurations and commands for the project are stored.

!!! note "Version control" 
    Git does not commit empty directories. To commit the `.docksal` directory into your Git repo create an empty `.gitkeep` file inside it ( or some other file of your choosing.)

## 2. Start containers

```bash
cd ~/projects/myproject
fin start
```

You will see output similar to the following:

```
Starting services...
Creating network "myproject_default" with the default driver
Creating volume "myproject_project_root" with local driver
Creating volume "myproject_host_home" with local driver
Creating myproject_cli_1
Creating myproject_db_1
Creating myproject_web_1
Changing user id in cli to 501 to match host user id...
Resetting permissions on /var/www...
Restarting php daemon...
Connected vhost-proxy to "myproject_default" network.
```

!!! tip "SSH key passphrase"
    **Note: SSH key passphrase** 
    If you are being asked for an SSH key passphrase for `id_dsa` or `id_rsa`, 
    remember, that these are **your** keys loaded from your `~/.ssh` folder into the `ssh-agent` container.  
    That's why their paths look like `/root/.ssh/...`. That is the path **inside the ssh-agent container**.  
    Provide password(s) if you want to use git or drush commands, that require ssh access within Docksal 
    (e.g. often a project init script or a composer script contains a repository checkout, 
    which would require an ssh key for access).

## 3. Your project is ready

Your project website is now running. You can visit the project url in your browser `http://myproject.docksal`

!!! tip "VIRTUAL HOST name"
    By default the virtual host name is equal to project folder name sans spaces and dashes, with the `.docksal` domain appended to it. `myproject => myproject.docksal`

## 3.1. Windows users, one more thing...

!!! attention "Windows users need HOSTS file configuration"
    On Windows you need to add every project to the hosts file.  
    `192.168.64.100  myproject.docksal`
