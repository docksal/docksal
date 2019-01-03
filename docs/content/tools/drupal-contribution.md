---
title: "Drupal Core Contribution"
aliases:
  - /en/master/tools/drupal-contribution/
---

There is a [boilerplate/starter](https://github.com/docksal/drupal8-contrib) that can be used to quickly spin up a local
environment for easy contribution to Drupal Core or contrib modules.

It can be enabled locally by:

1. Clone the repository:
    ```
    git clone git@github.com:docksal/drupal8-contrib.git core
    ```

1. Initialize the project:
    ```
    fin init
    ```
   This will clone Drupal core into the `docroot` directory. From there, patches
   can quickly be made for contribution.

1. PHPUnit can be run locally:
    ```
    fin phpunit core/path/to/directory/or/file
    ```
