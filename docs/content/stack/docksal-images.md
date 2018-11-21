---
title: "Docksal images"
weight: 6
---
## Docksal images and versions {#docksal-images}

To see all Docker Hub images produced and supported by Docksal team run:

```bash
fin image registry
```

To get all tags of a certain image provide its name with the same command. For example:

```bash
fin image registry docksal/db
```

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](/fin/custom-commands/) (e.g., `fin init`, which will call `.docksal/commands/init`). Put project specific initialization tasks there, like:

- initialize the Docksal configuration
- import databases or perform a site install
- compile SASS
- run DB updates, special commands, etc.
- run Behat tests

### Sample projects

For a working example of a Docksal powered project with `fin init` take a look at:

- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)
- [WordPress sample project](https://github.com/docksal/wordpress)
