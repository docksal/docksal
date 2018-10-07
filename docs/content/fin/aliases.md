---
title: "Project aliases"
---

Usually, fin executes in the context of the current folder (project). With use of aliases you can have fin execute in 
the context of another folder without navigating to it.

When you start project for the first time, an alias is created automatically for that project.

```bash
cd ~/Projects/demo
fin up
```

Now you can execute commands for `demo` project from anywhere:

```bash
fin @demo status
fin @demo stop
```

`drush` will also work properly:

```bash
fin @demo drush updb
```

You can also create a custom alias that would point to an arbitrary folder, for instance to point to a Drupal sub-site:

```bash
fin alias ~/Projects/demo/docroot/sites/subsite demo1
```

You can use Drush aliases along with fin aliases. To execute status for `@dev` Drush alias of the `demo` project:

```bash
fin @demo drush @dev status
```
