---
title: "PHP Code Sniffer"
---


`phpcs` and `phpcbf` are readily available in the cli container.


## Using as a custom fin command

It's recommended to see how to [extend fin with custom commands](../fin/custom-commands.md) first.

From your project's root folder (where the `.docksal` folder is) download the sample `phpcs` command:

```bash
mkdir -p .docksal/commands
curl -fsSL https://raw.githubusercontent.com/docksal/docksal/master/examples/.docksal/commands/phpcs -o .docksal/commands/phpcs
chmod +x .docksal/commands/phpcs
```

Run `fin phpcs docroot/sites/all/modules/custom` or any path you want to run sniffer against.  
See `fin help phpcs` for options.

Modify `.docksal/commands/phpcs` script as you see fit.

A command for `phpcbf` can be created in a similar fashion.


## Using directly

Instead of installing or creating custom commands you can use `phpcs`/`phpcbf` directly every time.  
From your project's root folder run:

```bash
fin run phpcs \
    --standard=Drupal -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/all/modules/custom
```

```bash
fin run phpcbf \
    --standard=Drupal -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/all/modules/custom
```
