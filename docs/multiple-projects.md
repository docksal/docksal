# Working with multiple projects

Docksal has a built-in vhost-proxy container that adds support for running multiple projects on the same `IP:port`. The container binds to `192.168.64.100:80` and routes web requests based on the host name.

On Windows you will need to manually append host to hosts file to route all of .docksal projects to 192.168.64.100.
