---
title: "Extending stock Docksal images"
---


{{% notice info %}}
Think contributing first and only then forking.  
If you find something is missing or can be improved in the stock Docksal Docker images and you believe others would 
benefit from it too, then go ahead and submit a feature request or a PR for the respective repo.
By using customized images you do not break any warranties, however this will make it more difficult to maintain, 
including seeking support from the community and Docksal maintainers if you run into issues.
{{% /notice %}}

There are several way to extend a stock Docksal image:

- use a [custom command](../fin/custom-commands.md) and script the adjustments there (e.g., as part of the `init` command)
- [maintain your own image](https://github.com/docksal/service-cli/issues/9#issuecomment-308774963) on Docker Hub 
based on a stock Docksal image
- use [docker-compose build](https://docs.docker.com/compose/reference/build/)

The latter is the recommended way of extending Docksal images and is covered below. 


## Configuration: Dockerfile

- Create a `Dockerfile` in `.docksal/services/<service-name>/Dockerfile`
- If you have additional local files (e.g., configs) used during the build, put them in the same folder
- Use an official Docksal image as a starting point in `FROM`
- Add customizations (read official Docker docs on [working with Dockerfiles](https://docs.docker.com/engine/reference/builder/) and [best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/))

Below is an example of extending the `cli` image with additional configs, apt, and npm packages:

**File `.docksal/services/cli/Dockerfile`**

```Dockerfile
# Use a stock Docksal image as the base
FROM docksal/cli:php7.1

# Install addtional apt packages
RUN apt-get update && apt-get -y --no-install-recommends install \
    netcat-openbsd \
    # Cleanup
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy additional config files
COPY ssh.conf /opt/cli/ssh.conf

# Inject additional SSH settings
RUN \
	cat /opt/cli/ssh.conf >> /home/docker/.ssh/config && \
	cat /home/docker/.ssh/config

# All further commands will be performed as the docker user.
USER docker

# Install additional global npm dependencies
RUN \
	# Initialize nvm environment
	. $NVM_DIR/nvm.sh && \
	# Install node packages
	npm install -g node-sass

# IMPORTANT! Switching back to the root user as the last instruction.
USER root
```

Here's another example for `web`:

```Dockerfile
# Use a stock Docksal image as the base
FROM docksal/web:2.1-apache2.4

RUN set -x \
	# Enabled extra modules
	&& sed -i '/^#.* expires_module /s/^#//' /usr/local/apache2/conf/httpd.conf
```

## Configuration: docksal.yml

If using default Docksal stacks (no `docksal.yml` in the project repo), create a `.docksal/docksal.yml` file in the repo 
with the following content:

```yaml
version: "2.1"

services:
  <service-name>:
    image: ${COMPOSE_PROJECT_NAME_SAFE}_<service-name>
    build: services/<service-name>
```

Replace `<service-name>` with the actual service name you are extending, e.g., `cli`.

If there is already a custom `docksal.yml` file in the project repo, then make the corresponding changes in it as shown 
above. Note: The existing `image` attribute should be replaced.

Following the previous example, here's what it would look like for `cli`:

```yaml
  cli:
    ...
    image: ${COMPOSE_PROJECT_NAME_SAFE}_cli
    build: services/cli
    ...
```

## Building

Building a customized image happens automatically with `fin project start`.
The built image will be stored locally and used as the service image from there on.

Additionally, `fin build` command is a proxy command to [docker-compose build](https://docs.docker.com/compose/reference/build/) 
and can be used for more advanced building scenarios. 

Note: it might seems like the image is being rebuilt every time project starts, but it really isn't.

There is no way for Docksal to know if your built image is the latest. Even if we checked for `Dockerfile` 
changes that would not be enough, because `Dockerfile` can use some other files that can change. Therefore 
the best Docksal option is to run `docker-compose build` every time.

`docker-compose build` launches `docker` which knows what files changed and can compare things. If `docker`
sees no changes then it does not **actually** rebuild image. You see output in the console, but there are 
no real changes made to images (and output in the console actually says exactly that). That output is 
basically just a check if nothing has changed. There is no good way to silence that output as in case there 
was some error the output would render very useful.
