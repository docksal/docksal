# Working with multiple projects/domains

Docksal has a built-in reverse proxy container that adds support for running multiple projects or using multiple (arbitrary domains).  
The container binds to `192.168.64.100:80` and routes web requests based on the host name.

DNS resolution and routing for `*.docksal` domains is automatically configured. 


## Default virtual host / domain name

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

Apply configuration changes with `fin project start` (`fin p start` for short).


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

Apply configuration changes with `fin project start` (`fin p start` for short).

Please note, that non `.docksal` domains (e.g. `example.com`) will not be resolved automatically.
You can use [fin hosts](advanced/fin.md#fin-help-hosts) command to add and manage additional domain names via the system's `hosts` file. 
See `fin help hosts`.
