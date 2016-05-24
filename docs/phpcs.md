# Using PHP Code Sniffer (phpcs) with Drude

phpcs is readily available in up-to-date version of cli container.

## Using as custom dsh command

It's recommended to see how to [extend dsh with custom commands](custom-commands.md) first.

From your project's root folder (where `.drude` is):

1. `mkdir -p .drude/commands`  
2. `cd .drude/commands`  
3. `curl https://raw.githubusercontent.com/blinkreaction/drude/develop/examples/.drude/commands/phpcs -ko phpcs`
4. `curl https://raw.githubusercontent.com/blinkreaction/drude/develop/examples/.drude/commands/phpcs.1 -ko phpcs.1`
5. `chmod +x phpcs`
6. `cd ../..`
7. `dsh phpcs`
8. Modify `.drude/commands/phpcs` script as you need and re-run any time with `dsh phpcs`

## Manual usage

Instead of installing custom command you can just enter it manually every time.  
From your project's root folder run

```bash
dsh run phpcs \
    --standard=Drupal -n \
    --extensions="php,module,inc,install,test,profile,theme" \
    --ignore="*.features.*,*.pages*.inc" \
    docroot/sites/modules/custom
```
