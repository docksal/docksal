---
title: "System: SSH agent"
weight: 2
aliases:
  - /en/master/advanced/ssh-agent/
---


The ssh-agent service allows adding multiple keys (including the ones protected with a passphrase) to a single pool of 
ssh keys, which can be shared across multiple projects.

The default ssh keys (`~/.ssh/id_rsa`, `~/.ssh/id_dsa`, `~/.ssh/id_ecdsa`) are loaded into the agent automatically.  
On macOS and Windows this happens when the Docksal VM is (re)started, on Linux - whenever `fin project start` is used.


## Project setup

To start using the ssh-agent service, add the following configuration option under the `volumes` section 
of the `cli` service in the project's `.docksal/docksal.yml` file:

```yaml
cli:
  ...
  volumes:
  ...
  # Shared ssh-agent socket
  - docksal_ssh_agent:/.ssh-agent:ro
  ...
```

Reset the `cli` container `fin project reset cli`.


## Command line reference

See `fin help ssh-key` for more information and usage guidelines.

```
$ fin help ssh-key
Manage SSH keys loaded into Docksal

  Private SSH keys loaded into the secure docksal-ssh-agent service are accessible to all project containers.	
  This allows containers to connect to the external SSH servers that require SSH keys	
  without a need to copy over the key into the container every time.	
  Default keys id_rsa/id_dsa/id_ecdsa are loaded automatically on every project start.	

Usage: fin ssh-key <command> [params]

Commands:
  add [key-name]           	Add a private SSH key from $HOME/.ssh by file name
                           	Adds all default keys (id_rsa/id_dsa/id_ecdsa) if no file name is given.
  ls                       	List SSH keys loaded in the docksal-ssh-agent
  rm                       	Remove all keys from the docksal-ssh-agent
  new [key-name]           	Generate a new SSH key pair

Examples:
  fin ssh-key add          	Loads all SSH keys with default names: id_rsa/id_dsa/id_ecdsa from $HOME/.ssh/
  fin ssh-key server_rsa   	Loads the key stored in $HOME/.ssh/server_id_rsa into the agent
  fin ssh-key new server2_rsa	Generates a new SSH key pair in ~/.ssh/server2_id_rsa
```

## Automatically Add Keys

Adding SSH keys automatically whenever Docksal project is started can be done by defining special variable(s) within
the `$HOME/.docksal/docksal.env` file. All variables should be prefixed with `SECRET_SSH_KEY_` and a small
identifier of the key. After that has been done, restart your project with `fin project restart`, and the keys will be added.

For example, assuming you have a private SSH key `$HOME/.ssh/acquia_key`, you would define a variable:

```
SECRET_SSH_KEY_ACQUIA='acquia_key'
```

When creating the variable use the file name within `$HOME/.ssh/` directory as the variable value. NOTE: the **private** key should be referenced, not the public one.
