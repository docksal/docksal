---
title: "Zero Configuration"
weight: 2
aliases:
  - /en/master/advanced/stack-config/
---
## Zero-configuration {#zero-configuration}

You can simply create a `.docksal` folder in your project root and run `fin project start` (`fin start` for short).
The default stack (`$HOME/.docksal/stacks/stack-default.yml`) will be loaded and used to create containers in this case.

This is a great way to start developing a new project. This approach can also be used on a permanent basis,
if your needs are simple. `stack-default.yml` extends the configuration from `services.yml`,
so you'll be getting the latest stack versions with every Docksal update.

### Zero-configuration Stacks

You can switch between pre-created zero-configuration stacks by adding the following line to your `docksal.env` file
and running `fin project reset`.

```
DOCKSAL_STACK="acquia"
```

The following stacks are available:

- `default` - web (Apache), db (MySQL), cli (assumed, when none specified)
- `default-nodb` - web (Apache), cli
- `acquia` - web (Apache), db (MySQL), cli, varnish, memcached, solr (used specifically for [Acquia](https://www.acquia.com/) hosted projects)
- `pantheon` - web (Nginx), db (MariaDB), cli, varnish, redis, solr (used specifically for [Pantheon](https://www.pantheon.io/) hosted projects)
- `node` - cli

{{% notice warning %}} Project must contain an `index.html` or `index.php` page of the `docroot` directory inside your project.{{% /notice %}}
