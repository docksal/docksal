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

```
docker run -d --name docksal-vhost-proxy --label "io.docksal.group=system" --restart=always --privileged --userns=host \
    -p "${DOCKSAL_VHOST_PROXY_PORT_HTTP:-80}":80 -p "${DOCKSAL_VHOST_PROXY_PORT_HTTPS:-443}":443 \
    -e PROJECT_INACTIVITY_TIMEOUT="${PROJECT_INACTIVITY_TIMEOUT:-0}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    docksal/vhost-proxy
```

## Configuration

`PROJECT_INACTIVITY_TIMEOUT`

Defines the timeout (e.g. 0.5h) of inactivity after which the project stack will be stopped.  
This option is inactive by default (set to `0`).

`PROJECT_DANGLING_TIMEOUT`

!!!warning "WARNING"
    This is a destructive option. Use at your own risk!

Defines the timeout (e.g. 168h) of inactivity after which the project stack and code base will be entirely wiped out from the host.  
This option is inactive by default (set to `0`).

For the cleanup job to work, proxy needs access to the directory, where project code bases are located on the host.  
Create a Docker bind volume pointing to the directory where projects are stored:

```
docker volume create --name docksal_projects --opt type=none --opt device=$PROJECTS_ROOT --opt o=bind

```

Start the proxy container with two additional options (in the middle): 

```
docker run -d --name docksal-vhost-proxy --label "io.docksal.group=system" --restart=always --privileged --userns=host \
    -p "${DOCKSAL_VHOST_PROXY_PORT_HTTP:-80}":80 -p "${DOCKSAL_VHOST_PROXY_PORT_HTTPS:-443}":443 \
    -e PROJECT_INACTIVITY_TIMEOUT="${PROJECT_INACTIVITY_TIMEOUT:-0}" \

    -e PROJECT_DANGLING_TIMEOUT="${PROJECT_DANGLING_TIMEOUT:-0}" \
    -v docksal_projects:/projects \
    
    -v /var/run/docker.sock:/var/run/docker.sock \
    docksal/vhost-proxy
```

`PROXY_DEBUG`

Set to `1` to enable debug logging. Check logs with `docker logs docksal-vhost-proxy`.

`PROXY_ACCESS_LOG`

Set to `1` to enable access log. Check logs with `docker logs docksal-vhost-proxy`.
