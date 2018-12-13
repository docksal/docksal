---
title: "Maintaining a Docker Image from Docksal Image"
weight: 1
---

While Docksal provides Behat in the CLI, some software projects, such as Acquia BLT, may expect a different structure than
the Docksal default. Here are the steps that can be taken to build an image:


1. Create image project, test and verify it worked as expected

    ```
    FROM docksal/cli:php7.1
    
    RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    
        DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes --no-install-recommends install \
        default-jre \
        lsof \
        # Cleanup
        && DEBIAN_FRONTEND=noninteractive apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    ```

2. Create an Automated Build on Docker Hub with a link to the repo where the image definition is maintained, and setup the 
build to trigger whenever `docksal/cli` is updated.

3. Update `docksal.yml` to pull **docker-user/blt-cli** image as opposed to **docksal/cli**:
    
    ```
    version: "2.1"
    
    services:
      cli:
        image: docker-user/blt-cli
    ```

4. Run `fin up`. The project will pull the image directly from Docker Hub.

{{% notice note %}}
When the image is updated, you will need to pull the latest changes from Docker Hub with `fin docker pull <image name>:<tag>`.
{{% /notice %}}