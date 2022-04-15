---
title: "Usage with Gitpod"
---

## Gitpod

[Gitpod](https://www.gitpod.io/) is a browser-based development environment.

## Getting Started

To get started, create a `.gitpod.yml` file within your project.

```yaml
tasks:
  - before: bash <(curl -fsSL https://get.docksal.io)
    init: fin init
```

Once created, you are ready to start your project within the [Gitpod Workspace](https://www.gitpod.io/docs/getting-started).

For more information on creating the Gitpod Configuration file, consult the [Gitpod Getting Started](https://www.gitpod.io/docs/getting-started) 
documentation.
