# docker-nginx-proxy

Automated nginx proxy for Docker containers using docker-gen

Inspired by https://github.com/jwilder/nginx-proxy.
Rebuilt using the [Alpine Linux](https://registry.hub.docker.com/_/alpine/) image.  

Containers must define a "VIRTUAL_HOST" environment variable to be recognized and routed by the vhost-proxy.

See https://github.com/blinkreaction/boot2docker-vagrant#vhost-proxy for details and instructions.

## Container Supervisor notes

Run

```
docker run -d --name vhost-proxy --label "group=system" --restart=always --privileged --userns=host \
	-p 80:80 -p 443:443 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /<PROJECTS_ROOT>:/<PROJECTS_ROOT> \
	docksal/nginx-proxy:supervisor
```
