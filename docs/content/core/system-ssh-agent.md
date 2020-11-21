---
title: "System: SSH Agent"
weight: 2
aliases:
  - /en/master/advanced/ssh-agent/
---


The ssh-agent service allows adding multiple keys (including the ones protected with a passphrase) to a single pool of 
SSH keys, which can be shared across multiple projects. It runs an SSH agent process whose Unix socket is mounted into
your project's cli container by default.

The default SSH keys (`~/.ssh/id_rsa`, `~/.ssh/id_dsa`, `~/.ssh/id_ecdsa`, `~/.ssh/id_ed25519`) are loaded into the
agent automatically. On macOS and Windows, this happens when the Docksal VM is (re)started, on Linux, whenever
`fin project start` is used.

Alternatively, you can run the ssh-agent service in a proxy mode, where your host's SSH agent is passed through to all
containers that talk to the ssh-agent service. This can be useful for CI where SSH keys are managed inside an SSH agent,
or if you already have an SSH agent up and running that you would like to reuse.


## Command Line Reference

See [fin help ssh-key](/fin/fin-help/#ssh-key) for more information and usage guidelines.


## Automatically Add Keys

Adding SSH keys automatically whenever Docksal project is started can be done by defining special variable(s) within
the `$HOME/.docksal/docksal.env` file. All variables should be prefixed with `SECRET_SSH_KEY_` plus the
identifier of the SSH key. After that has been done, restart your project with `fin project restart`, and the keys will be added.

For example, assuming you have a private SSH key `$HOME/.ssh/acquia_key`, you would define a variable:

```
SECRET_SSH_KEY_ACQUIA='acquia_key'
```

When creating the variable use the file name within `$HOME/.ssh/` directory as the variable value. NOTE: the **private** key should be referenced, not the public one.


## Manually Add Keys

To add a key manually, run `fin ssh-key add <key_filename>` and it will be manually loaded. NOTE: this key will only be 
available to the containers until the next ssh-agent restart.


## Using the host's SSH agent

The default behavior for the ssh-agent service is to manage SSH keys itself. There are two ways to enable SSH agent
pass-through:

  * When running Docksal as part of a CI job, set the environment variable `CI` to `1`. This will result in ssh-agent
    starting in proxy mode by default.
  * By setting the environment variable `DOCKSAL_SSH_AGENT_USE_HOST` to `1`. This will explictly enable proxy mode. Set
    it by running `fin config set --global DOCKSAL_SSH_AGENT_USE_HOST=1` followed by `fin system reset ssh-agent`.

On Linux, ssh-agent is able to directly mount your host SSH agent's Unix socket into the container.

On Windows and macOS, the `socat` utility is used to convert your local Unix socket to a TCP-endpoint and back again.
To do so, a local port configured by the `DOCKSAL_SSH_PROXY_PORT` environment variable (defaults to `30001`) is opened.

**Caution:** if other users have local access to your system, they could connect to this port and use your keys. The
port is only opened on an internal network interface and is not accessible from your LAN. Use with care!
