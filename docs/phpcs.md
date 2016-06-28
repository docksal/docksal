# Using PHP Code Sniffer with Drude

phpcs and phpcbf are readily available in up-to-date version of cli container.

## Using as custom dsh command

It's recommended to see how to [extend dsh with custom commands](custom-commands.md) first.

From your project's root folder (where `.drude` folder is):

1. Download example `phpcs` command

    ```
    mkdir -p .drude/commands
    curl https://raw.githubusercontent.com/blinkreaction/drude/develop/examples/.drude/commands/phpcs -ko .drude/commands/phpcs
    chmod +x .drude/commands/phpcs
    ```
2. Use as `dsh phpcs docroot/sites/all/modules/custom` or any path you want to run sniffer against. See `dsh help phpcs`
3. Modify `.drude/commands/phpcs` script as you need
4. In the same way you can create script for `phpcbf` as it uses the same set of parameters

## Manual usage

Instead of installing custom command you can just enter it manually every time.  
From your project's root folder run

```bash
dsh run phpcs \
    --standard=Drupal -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/all/modules/custom
```

```bash
dsh run phpcbf \
    --standard=Drupal -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/all/modules/custom
```
