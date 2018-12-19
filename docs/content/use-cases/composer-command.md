---
title: "Docker Composer Command Variable for the CLI Container"
weight: 1
---

Docker composer gives the ability to configure which command to run on `cli` start.

```
services:
  cli:
    command: bundle exec thin -p 3000
```

The command can also be in a list:
```
    command: ["bundle", "exec", "thin", "-p", "3000"]
```

This can be useful for automatically initializing services, such as:
```
version: "2.1"

services:
  cli:
    # Extend the stock cli image (see .docksal/services/cli/Dockerfile)
    image: ${COMPOSE_PROJECT_NAME_SAFE}/cli
    build: services/cli
    # Custom command to run when the container starts
    # Always use "bash -lc 'command'" to initialize the docker user environment
    # Using nodemon for live reload
    command: ["bash", "-lc", "nodemon index.js"]
```
