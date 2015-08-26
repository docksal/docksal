# Working with multiple projects

Follow the [setup](#setup) instructions for each project making sure that ports used by containers accross all projects do not collide (e.g. two containers cannot use port 80 at the same time).

This requires a slight modification of the `docker-compose.yml`.
Edit the `ports` key for each container that does port mapping in `docker-compose.yml`.
You can either map unique ports for each container or use dedicated IPs:

**Unique ports**

```yml
ports:
  - "8080:80"
  - "8443:443"
```

**Dedicated IP**

```yml
ports:
  - "192.168.10.11:80:80"
  - "192.168.10.11:443:443"
```

For Mac and Windows see (boot2docker-vagrant/Vagrantfile)[https://github.com/blinkreaction/boot2docker-vagrant/blob/master/Vagrantfile] for instructions on enabling additional IPs for the Boot2docker VM.
