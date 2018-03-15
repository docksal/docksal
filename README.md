# Virtual host proxy Docker image for Docksal

Automated HTTP/HTTPS virtual host proxy and container supervisor for Docksal.

This image(s) is part of the [Docksal](http://docksal.io) image library.

## Features

- HTTP/HTTPS virtual host routing
- On-demand stack starting (upon a HTTP/HTTPS request)
- Stack stopping after a given period of inactivity
- Stack cleanup after a given period of inactivity

## Usage

Start the proxy container:

```bash
docker run -d --name docksal-vhost-proxy --label "io.docksal.group=system" --restart=always --privileged --userns=host \
    -p "${DOCKSAL_VHOST_PROXY_PORT_HTTP:-80}":80 -p "${DOCKSAL_VHOST_PROXY_PORT_HTTPS:-443}":443 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    docksal/vhost-proxy
```

## Container configuration 

Proxy reads routing settings from container labels. The following labels are supported:

`io.docksal.virtual-host`

Virtual host mapping. Supports any domain (but does not handle DNS), multiple values separated by commas, wildcard 
sub-domains.

Example: `io.docksal.virtual-host=example1.com,*.example2.com`


`io.docksal.virtual-port`

Virtual port mapping. Useful when a container exposes an non-default HTTP port (other than port `80`).
Only supports HTTP, single value.  

Example: `io.docksal.virtual-port=3000`

### Example

Launching a nodejs app container using port `3000` and host `myapp.example.com`

```bash
docker run -d --name=nodejs \
	-v $(pwd):/app \
	--label=io.docksal.virtual-host=myapp.example.com \
	--label=io.docksal.virtual-port=3000 \
	--expose 3000 \
	node:alpine \
	node /app/index.js
``` 

## Advanced proxy configuration

These advanced settings can be used in CI sandbox environments and help keep the resource usage down by stopping 
Docksal project containers after a period of inactivity. Projects are automatically restarting upon a new HTTP request.

`PROJECT_INACTIVITY_TIMEOUT`

Defines the timeout (e.g. 0.5h) of inactivity after which the project stack will be stopped.  
This option is inactive by default (set to `0`).

`PROJECT_DANGLING_TIMEOUT`

**WARNING: This is a destructive option. Use at your own risk!**

Defines the timeout (e.g. 168h) of inactivity after which the project stack and code base will be entirely wiped out from the host.  
This option is inactive by default (set to `0`).

For the cleanup job to work, proxy needs access to the projects directory on the host.  
Create a Docker bind volume pointing to the directory where projects are stored:

```
docker volume create --name docksal_projects --opt type=none --opt device=$PROJECTS_ROOT --opt o=bind

```

then pass it using `-v docksal_projects:/projects` in `docker run` command.

Example (extra configuration in the middle): 

```bash
docker run -d --name docksal-vhost-proxy --label "io.docksal.group=system" --restart=always --privileged --userns=host \
    -p "${DOCKSAL_VHOST_PROXY_PORT_HTTP:-80}":80 -p "${DOCKSAL_VHOST_PROXY_PORT_HTTPS:-443}":443 \
    -e PROJECT_INACTIVITY_TIMEOUT="${PROJECT_INACTIVITY_TIMEOUT:-0}" \

    -e PROJECT_INACTIVITY_TIMEOUT="${PROJECT_INACTIVITY_TIMEOUT:-0}" \
    -e PROJECT_DANGLING_TIMEOUT="${PROJECT_DANGLING_TIMEOUT:-0}" \
    -v docksal_projects:/projects \
    
    -v /var/run/docker.sock:/var/run/docker.sock \
    docksal/vhost-proxy
```

## Logging and debugging

The following container environment variables can be used to enabled various logging options (disabled by default). 

`ACCESS_LOG` - Set to `1` to enable access logging.
`DEBUG_LOG` - Set to `1` to enable debug logging.
`STATS_LOG` - Set to `1` to enable project stats logging.

Check logs with `docker logs docksal-vhost-proxy`.
