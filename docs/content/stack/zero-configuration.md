---
title: "Zero Configuration"
weight: 2
aliases:
  - /en/master/advanced/stack-config/
---
## Zero-configuration {#zero-configuration}

You can simply create a `.docksal` directory in your project root and run `fin project start` (`fin start` for short) 
to get a Docksal-powered stack up and running for a project.

The default LAMP [stack](/stack/understanding-stack-config/) (`DOCKSAL_STACK=default`) with Apache, PHP, and MySQL 
will be used to create containers. The default Document Root path for web-accessible files is `docroot`.

This is a great way to start developing a new project. This approach can also be used on a permanent basis,
if your needs are simple. The default stack receives regular updates with every Docksal update.

{{% notice tip %}}
You can run `fin init` in an empty (or an existing project) folder for a wizard experience. See [getting-started/project-setup](/getting-started/project-setup/)
for an example.
{{% /notice %}}

{{% notice warning %}}
Project must contain an `index.html` or `index.php` page in the `docroot` directory inside your project.
{{% /notice %}}


### Zero-configuration Stacks {#stacks}

You can switch between managed zero-configuration stacks for you project like this: 

```
fin config set DOCKSAL_STACK="acquia"
fin project reset
```

This is a great way to use a more tailored stack setup without digging deep into the configuration.

For more details on managed stacks, see [Default Configurations](/stack/understanding-stack-config/#default-configurations).
