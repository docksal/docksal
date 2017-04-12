# Working with multiple projects/domains

Docksal has a built-in reverse proxy container that adds support for running multiple projects or using multiple (arbitrary domains).  
The container binds to `192.168.64.100:80` and routes web requests based on the host name.


## macOS and Linux

On macOS and Linux you don't need to do anything. Routing is automatically configured upon the first `fin update`. 


## Windows

On Windows you will need to manually add the virtual host of each of your Docksal projects to the 
[hosts file](https://en.wikipedia.org/wiki/Hosts_(file)) to route it to `192.168.64.100`.

Example [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)):

```
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.

drupal.docksal    192.168.64.100
wordpress.docksal    192.168.64.100
myproject.docksal    192.168.64.100
```


## Finding out the hostname

To find the current project's virtual host name run `fin config | grep '^VIRTUAL_HOST'`.

```bash
$ fin config | grep '^VIRTUAL_HOST'
VIRTUAL_HOST: myproject.docksal
VIRTUAL_HOST_ALIASES: *.myproject.docksal
```

By default, the project domain value (`myproject.docksal`) is derived from the project folder name sans spaces and dashes.  
Also, wildcard sub-domain aliases (`*.myproject.docksal`) are available out-of-the box.


## Overriding the default domain name

The default domain name can be overridden via either `docksal-local.env` or `docksal.env` file in the project:

`docksal.env:`

```bash
VIRTUAL_HOST=custom-domain.docksal
```

Check configuration change:

````
$ fin config | grep '^VIRTUAL_HOST'
VIRTUAL_HOST: custom-domain.docksal
VIRTUAL_HOST_ALIASES: *.custom-domain.docksal
````

Apply configuration changes with `fin up`.


## Using arbitrary custom domains

A completely custom domain(s) can be assigned by extending the `io.docksal.virtual-host` label of the `web` container in 
either `docksal-local.yml` or `docksal.yml` file in the project.

```yaml
version: "2.1"

services:
  web:
    labels:
      ...
      - io.docksal.virtual-host=${VIRTUAL_HOST},*.${VIRTUAL_HOST},example.com,mydomain.com,*.mydomain.com
      ...
```

`io.docksal.virtual-host=${VIRTUAL_HOST},*.${VIRTUAL_HOST}` is the default value.

Apply configuration changes with `fin up`.

Please note, that non `.docksal` domains (e.g. `example.com`) will not be resolved automatically.
You will have to modify your hosts file map those to Docksal's default IP (`192.168.64.100`):

```
example.com  192.168.64.100
mydomain.com subdomain.mydomain.com  192.168.64.100
```
