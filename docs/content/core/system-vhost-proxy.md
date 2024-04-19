---
title: "System: Virtual Host Proxy"
weight: 2
aliases:
    - /en/master/advanced/multiple-projects/
---


Docksal has a built-in reverse proxy container that adds support for running multiple projects or using multiple (arbitrary domains).  
By default, the container binds to `192.168.64.100:80` and routes web requests based on the host name.

[DNS resolution](/core/system-dns/) for `*.docksal` domains is automatically configured for your host and project containers. 


## Default Virtual Host / Domain Name

To find the current project's virtual host name run `fin config | grep '^VIRTUAL_HOST'`.

```bash
$ fin config | grep '^VIRTUAL_HOST'
VIRTUAL_HOST: myproject.docksal
VIRTUAL_HOST_ALIASES: *.myproject.docksal
```

By default, the project domain value (`myproject.docksal`) is derived from the project folder name sans spaces and dashes.  
Also, wildcard sub-domain aliases (`*.myproject.docksal`) are added automatically.


## Overriding the Default Domain Name

The default project domain can be set/overridden as follows:

```bash
fin config set VIRTUAL_HOST=custom-domain.docksal
```

Use a single domain in `VIRTUAL_HOST`. Wildcards are added automatically.

Check configuration changes:

````bash
$ fin config | grep '^VIRTUAL_HOST'
VIRTUAL_HOST: custom-domain.docksal
VIRTUAL_HOST_ALIASES: *.custom-domain.docksal
````

Apply configuration changes with `fin project start` (`fin p start` for short).

Use `fin vhosts` to confirm virtual host configuration was applied in `vhost-proxy`.


## Using Custom Domains {#custom-domains}

You can use custom domains by overriding the `io.docksal.virtual-host` label of the `web` container in 
either `docksal-local.yml` or `docksal.yml` file in the project.

Multiple domains have to be separated by commas. Wildcards are supported on the left or right side, but not inbetween.

```yaml
services:
  web:
    labels:
      ...
      - io.docksal.virtual-host=example.com,mydomain.com,*.mydomain.com
      ...
```

{{% notice note %}}
The default value for the `web` service is `io.docksal.virtual-host=${VIRTUAL_HOST},*.${VIRTUAL_HOST},${VIRTUAL_HOST}.*`.
{{% /notice %}}

Apply configuration changes with `fin project start` (`fin p start` for short).

Use `fin vhosts` to confirm virtual host configuration was applied in `vhost-proxy`.

This approach can be used to map custom domains to any other service in the project stack.

{{% notice warning %}}
Automatic DNS resolution for non-`.docksal`/`.docksal.site` domains (e.g., `example.com`) is not supported. See [Managing DNS Manually](/core/system-dns#manual) 
for a workaround.
{{% /notice %}}

## Using Custom Ports {#custom-ports}

The `io.docksal.virtual-host` lable allows setting the domain(s) that will be routed to an HTTP service (listening on port 80) in your project stack.
If the service inside the container listens on a different port, you can use the `io.docksal.virtual-port` lable to override the default port mapping.

This is how it is set up for the Mailpit service definition found in `services.yml`:

```yaml
 # Mailpit
 mail:
   hostname: mail
   image: ${MAILPIT_IMAGE:-axllent/mailpit}
   volumes:
     - project_root:/var/www:ro,nocopy,cached  # Project root volume (read-only)
   labels:
     - io.docksal.virtual-host=mail.${VIRTUAL_HOST},mail.${VIRTUAL_HOST}.*
     - io.docksal.virtual-port=8025
     - io.docksal.cert-name=${VIRTUAL_HOST_CERT_NAME:-none}
```

In the example above, Mailpit application listends on port `8025` inside the `mail` container.
Docksal's vhost-proxy handles the routing and mapping from `http(s)://mail.${VIRTUAL_HOST}` (e.g., http://mail.myproject.docksal.site) to http://mail:8025 (internal endpoint accessible only between containers in a project stack).

Your host machine as well as containers will be able to access the exposed virtual host endpoint.

{{% notice info %}}
You may also need to [expose the port on the container](https://docs.docker.com/compose/compose-file/compose-file-v2/#expose)
if it's not already exposed in the base image.
{{% /notice %}}

## Adding a Custom Certificate {#custom-certificate}

Put your certificates for your project's virtual host into `$HOME/.docksal/certs`. 
For example, if your project's virtual host is `example.com`, then put CRT and KEY files as:

```
$HOME/.docksal/certs/example.com.crt
$HOME/.docksal/certs/example.com.key
```

If you never had `$HOME/.docksal/certs` directory before, you will need to do 
`fin system reset` for docksal-vhost-proxy to find it.

When using a shared cert (multiple domains), you can set the shared cert file name like this:

```
fin config set VIRTUAL_HOST_CERT_NAME='example.com'
```

Restart the project with `fin project restart`
