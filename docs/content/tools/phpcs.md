---
title: "PHP Code Sniffer"
aliases:
  - /en/master/tools/phpcs/
---


`phpcs` and `phpcbf` are readily available in the cli container. Both [Drupal Coding Standards](https://www.drupal.org/docs/develop/standards) and [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards) 
have been installed and are ready to use.


## Using as a Custom fin Command

It's recommended to see how to [extend fin with custom commands](/fin/custom-commands/) first.

From your project's root folder (where the `.docksal` folder is located), download the sample `phpcs` command:

### For Drupal

```bash
mkdir -p .docksal/commands
curl -fsSL https://raw.githubusercontent.com/docksal/docksal/master/examples/.docksal/commands/phpcs_drupal -o .docksal/commands/phpcs
chmod +x .docksal/commands/phpcs
```

Run `fin phpcs docroot/sites/all/modules/custom` or any path you want to run sniffer against.  
See `fin help phpcs` for options.

### For WordPress

```bash
mkdir -p .docksal/commands
curl -fsSL https://raw.githubusercontent.com/docksal/docksal/master/examples/.docksal/commands/phpcs_wordpress -o .docksal/commands/phpcs
chmod +x .docksal/commands/phpcs
```

Run `fin phpcs docroot/wp-content/plugins` or any path you want to run sniffer against.  
See `fin help phpcs` for options.


For both of the examples above modify `.docksal/commands/phpcs` script as you see fit.

A command for `phpcbf` can be created in a similar fashion.


## Using Directly

Instead of installing or creating custom commands you can use `phpcs`/`phpcbf` directly every time.  
From your project's root folder run:

### With Drupal

```bash
fin run phpcs \
    --standard="Drupal,DrupalPractice" -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/all/modules/custom
```

```bash
fin run phpcbf \
    --standard="Drupal,DrupalPractice" -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/all/modules/custom
```

### With WordPress

```bash
fin run phpcs \
    --standard="WordPress" -n \
    docroot/wp-content/plugin
```

```bash
fin run phpcbf \
    --standard="WordPress" -n \
    docroot/wp-content/plugins
```

