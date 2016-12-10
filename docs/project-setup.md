# Configure a project to use Docksal

Docksal is capable of running a project without specifying a configuration for a project. 
It has a default configuration it will use to build containers and setup a virtual host.

Initial configuration is done once per project (e.g. by a team lead) and committed into the project repo. 
Presence of the `.docksal` folder in the project directory is a good indicator a project is already using Docksal.

## 1. Create a project directory 

```bash
mkdir ~/projects/myproject
mkdir ~/projects/myproject/docroot
mkdir ~/projects/myproject/.docksal
```

You can checkout existing project into the `docroot` of this new directory. In the docroot folder you can add any project files you want whether it's a plain HTML, PHP-based CMS or pure PHP project.

All project specific Docksal configurations and commands will be stored inside `.docksal`.

!!! note "Version control" 
    Git does not commit empty directories. To commit `.docksal` directory into Git repo create an empty `.gitkeep` file inside it.

## 2. Start containers

```bash
cd ~/projects/myproject
fin start
```

You should see output like the following:

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

!!! tip "SSH key password"
    If you are being asked for password to SSH keys `id_dsa` or `id_rsa`, please know that these are **your** keys that were copied over from your `~/.ssh` folder into SSH Agent's container. Their paths looks like `/root/.ssh/...` because that's the path **inside container**. Please provide password(s) to your keys if you want to use git or drush commands that require your SSH keys within Docksal (e.g. often project init script or composer script contains repository checkout that would require your key).

## 3. Your project is ready

Your project site is now running. You can visit project url in your browser `http://myproject.docksal`

!!! tip "VIRTUAL HOST name"
    By default virtual host name is equal to project folder name sans spaces and dashes, with `.docksal` domain appended to it. `myproject => myproject.docksal`

## 3.1. Windows users, one more thing...

!!! attention "Windows users need HOSTS file configuration"
    On Windows you need to append your project to the hosts file for every project `192.168.64.100  myproject.docksal`
