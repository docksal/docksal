---
title: "PHP Code Sniffer"
aliases:
  - /en/master/tools/phpcs/
---


`phpcs` and `phpcbf` are readily available in the cli container. Both [Drupal Coding Standards](https://www.drupal.org/docs/develop/standards) and [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards)
have been installed and are ready to use.


## Using as an addon

We have converted this into a Docksal Addon which can be installed running the `addon` subcommand.

```
fin addon install phpcs
```

This will enable the following to be ran.

```bash
# Running PHPCS
fin phpcs cs docroot/sites/all/modules/custom
```

```bash
# Running PHPCBF
fin phpcs cbf docroot/sites/all/modules/custom
```

# Using Directly

Instead of installing an addon you can use `phpcs`/`phpcbf` directly every time.
Anywhere from within your project's folder the following commands below can be ran.

### With Drupal

```bash
fin run phpcs \
    --standards="Drupal,DrupalPractice" -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/all/modules/custom
```

```bash
fin run phpcbf \
    --standards="Drupal,DrupalPractice" -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/all/modules/custom
```

### With WordPress

```bash
fin run phpcs \
    --standards="WordPress" -n \
    docroot/wp-content/plugin
```

```bash
fin run phpcbf \
    --standards="WordPress" -n \
    docroot/wp-content/plugins
```

