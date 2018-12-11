---
title: "NodeJS"
---

## NodeJS

The `docksal/cli:2.5` service comes pre-installed with NodeJS 8.11.3. This version is stored in a persistent volume in
`home/docker`.

When updating `cli` images, either from an explicit image tag or through a Docksal upgrade, and the images use a different 
NodeJS version, it will be necessary to run `fin project reset cli`
to update the version in the docker user's profile inside the image.

See additional documentation on [installing alternate versions of NodeJS](/use-cases/nodejs).
