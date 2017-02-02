# Using ssh-agent service

The ssh-agent service allows adding multiple keys (including the ones protected with a passphrase) to a single pool of 
ssh keys, which can be shared across multiple projects.

The default ssh keys (`~/.ssh/id_rsa`, `~/.ssh/id_dsa`, `~/.ssh/id_ecdsa`) are loaded into the agent automatically.  
On macOS and Windows this happens when the Docksal VM is (re)started, on Linux - whenever `fin up` is used.


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

Reset the `cli` container `fin reset cli`.


## Command line reference

See `fin help ssh-add` for more information and usage guidelines.

```
$ fin help ssh-add
fin ssh-add - Add private key identities to the ssh-agent.
Usage: fin ssh-add [-lD] [key]

When run without arguments, picks up the default key files (~/.ssh/id_rsa, ~/.ssh/id_dsa, ~/.ssh/id_ecdsa).
A custom key name can be given as an argument: fin ssh-add <keyname>.

NOTE: <keyname> is the file name within ~/.ssh (not full path to file).
Example: fin ssh-add my_custom_key_rsa

The options are as follows:
  -D                            Deletes all identities from the agent.
  -l                            Lists fingerprints of all identities currently represented by the agent.
```
