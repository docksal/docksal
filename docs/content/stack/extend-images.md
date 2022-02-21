---
title: "Extending Stock Images"
weight: 7
aliases:
  - /en/master/advanced/extend-images/
---


{{% notice info %}}
Think contributing first and only then forking.  
If you find something is missing or can be improved in the stock Docksal Docker images and you believe others would 
benefit from it too, then go ahead and submit a feature request or a PR for the respective repo.
By using customized images you do not break any warranties, however this will make it more difficult to maintain, 
including seeking support from the community and Docksal maintainers if you run into issues.
{{% /notice %}}

There are several way to extend a stock Docksal image:

- use a [custom command](#custom-command) and script the adjustments there 
- use docker-compose build to [configure a Dockerfile](#docker-file)
- [maintain your own image](#maintain-image) on Docker Hub based on a stock Docksal image

## Use a Custom Command {#custom-command}

This method is sufficient for many use cases.

Create a [custom command](/fin/custom-commands/) to add the necessary tools to the image, e.g.:

```
fin exec sudo apt-get update
fin exec sudo apt-get install php7.0-redis
```

## Configuration: Dockerfile {#docker-file}

This is the recommended way of extending Docksal images with [docker-compose build](https://docs.docker.com/compose/reference/build/).
The image file is created and maintained locally as part of your project repo.

- Create a `Dockerfile` in `.docksal/services/<service-name>/Dockerfile`
- If you have additional local files (e.g., configs) used during the build, put them in the same folder
- Use an official Docksal image as a starting point in `FROM`
- Add customizations (read official Docker docs on [working with Dockerfiles](https://docs.docker.com/engine/reference/builder/) and [best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/))

Below is an example of extending the `cli` image with additional configs, apt, and npm packages:

**File `.docksal/services/cli/Dockerfile`**

```Dockerfile
# Note how we use cli:2 here, which refers to the latest available 2.x version
# So that we wouldn't need to update this every time new version of Docksal cli releases
FROM docksal/cli:2-php7.3

# Install additional apt packages
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
SHELL ["/bin/bash", "-c"]

# Install additional global npm dependencies
RUN \
	# Initialize the user environment (this loads nvm)
	. $HOME/.profile && \
	# Install node packages
	npm install -g node-sass

# IMPORTANT! Switching back to the root user as the last instruction.
USER root
```

Here's another example for `web`:

```Dockerfile
# Use a stock Docksal image as the base
FROM docksal/apache:2.4-2.4

RUN set -x \
	# Enabled extra modules
	&& sed -i '/^#.* expires_module /s/^#//' /usr/local/apache2/conf/httpd.conf
```

### Configuration: docksal.yml {#extend-docksal.yml}

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

### Building

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

## Maintain Your Own Docker Image {#maintain-image}

Of all of the options, this requires the highest level of knowledge of Docker and Docksal. 
You may find this method beneficial when you are using the same image definition across multiple projects. 

If you think your changes should be part of the stock image, submit a pull request.

### Setup an automated image build on Docker Hub

- Create a separate Docker image project ([see image examples above](#docker-file))
- Use an official Docksal service image as the base (`FROM` directive in the `Dockerfile`)
- Make desired adjustments ([see the Dockerfile reference](https://docs.docker.com/engine/reference/builder/))
- Build the image
- Test and verify the image works with Docksal ([see extending `docksal.yml` file above](#extend-docksal.yml))
- Push your image project to Github or Bitbucket as a public repository
- On Docker Hub, create an "Automated Build" project and link your image repository
- Under "Build Settings", specify the branch you want to create a build from and what the image tag should be called
- In the "Linked Repositories" section, specify the image you used as the base (e.g. `docksal/cli`). This way, 
every time Docksal updates the stock image on Docker Hub, your custom image will automatically be rebuilt and updated.

### Configure your project stack to use the custom image

Assuming your project stack is using stock Docksal services, you can override the service image like this:

```bash
fin config set <SERVICE>_IMAGE=<custom-image>
```

Example:

```bash
fin config set CLI_IMAGE='wodby/php:7.1-4.11.12'
``` 

You can also override the `image` property of a service via `docksal.yml` (advanced users).

Run `fin project start` to update the stack configuration and pull the new image from Docker Hub. 

{{% notice note %}}
When your custom image is updated, you will need to pull the latest changes from Docker Hub. This can be done with 
`fin docker pull <custom-image>` or `fin update --project-images`.
{{% /notice %}}
