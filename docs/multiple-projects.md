# Working with multiple projects

## Using vhost-proxy (boot2docker-vagrant)

[boot2docker-vagrant](https://github.com/blinkreaction/boot2docker-vagrant) has a built-in vhost-proxy container that adds support for running multiple projects on the same `IP:port`. The container binds to `192.168.64.100:80` (the default box IP address) and routes web requests based on the Host header.

See [boot2docker-vagrant docs](https://github.com/blinkreaction/boot2docker-vagrant/blob/develop/docs/networking.md#vhost-proxy) for more information and configuration instructions.


## Without vhost-proxy (Mac, Windows, Linux)

Follow the [setup](env-setup.md) instructions for each project making sure that ports used by containers accross all projects do not collide (e.g. two containers cannot use port 80 at the same time).

This requires a slight modification of the `docker-compose.yml`.
Edit the `ports` key for each container that does port mapping in `docker-compose.yml`.
You can either map unique ports for each container or use dedicated IPs.

## Unique ports

```yml
ports:
  - "8080:80"
  - "8443:443"
```

## Dedicated IP

```yml
ports:
  - "192.168.64.100:80:80"
  - "192.168.64.100:443:443"
```

For Mac and Windows see [boot2docker-vagrant/vagrant.yml](https://github.com/blinkreaction/boot2docker-vagrant/blob/master/vagrant.yml) for instructions on enabling additional IPs for the Boot2docker VM.
