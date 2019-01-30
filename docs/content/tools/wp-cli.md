---
title: "WP-CLI"
aliases:
  - /en/master/tools/wp-cli/
---


WP-CLI provides a command-line interface for many actions you might perform in the WordPress admin.

Please refer to [wp-cli.org](https://wp-cli.org/) or the official [WP-CLI Handbook](https://make.wordpress.org/cli/handbook/) for usage details.



## Usage

From the host via `fin`:

```
fin wp --version
```

From with the cli container (`fin bash`) wp can be called directly:

```
wp --version
```

{{% notice note %}}
Unless globally accessible site aliases are used, wp-cli must be run inside the WordPress document root to be able to
detect the WordPress instance and read the DB connection settings.
{{% /notice %}}
