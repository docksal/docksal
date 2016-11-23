# Using PHP Code Sniffer with Docksal

phpcs and phpcbf are readily available in up-to-date version of cli container.

## Using as custom fin command

It's recommended to see how to [extend fin with custom commands](custom-commands.md) first.

From your project's root folder (where `.docksal` folder is):

1. Download example `phpcs` command

    ```
    mkdir -p .docksal/commands
    curl https://raw.githubusercontent.com/docksal/docksal/master/examples/.docksal/commands/phpcs -ko .docksal/commands/phpcs
    chmod +x .docksal/commands/phpcs
    ```
2. Use as `fin phpcs docroot/sites/all/modules/custom` or any path you want to run sniffer against. See `fin help phpcs`
3. Modify `.docksal/commands/phpcs` script as you need
4. In the same way you can create script for `phpcbf` as it uses the same set of parameters

## Manual usage

Instead of installing custom command you can just enter it manually every time.  
From your project's root folder run

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
