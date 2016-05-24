# Using PHP Code Sniffer (phpcs) with Drude

phpcs is readily available in up-to-date version cli container.

## Using as custom dsh command

It's recommended to see how to [extend dsh with custom commands](custom-commands.md) first.

1. Download `phpcs` and `phpcs.1` from [example dsh commands folder](https://github.com/blinkreaction/drude/tree/develop/examples/.drude/commands) into your `.drude/commands` folder.
2. `chmod +x .drude/commands/phpcs`
3. Use as `dsh phpcs`

## Manual usage

From your project's root folder run

```
dsh run "phpcs \
    --standard=Drupal -n \
    --extensions=php,module,inc,install,test,profile,theme \
    --ignore=*.features.*,*.pages*.inc \
    docroot/sites/modules/custom"
```
