# DSH custom commands

Extending DSH with your custom commands is supported in DSH 1.17 and higher.

1. Create a cutom command

    File `.drude/commands/updb` (Notice **no extension**. Script name should match command name)

    ```bash
    #!/bin/bash
    dsh drush updb $1
    ```

2. Set executable bit: `chmod +x .drude/commands/updb`
3. Use as regular dsh command: `dsh updb`
4. Passing parameters also works: `dsh updb -y`

## Advanced use

It is not imperative to use bash. You can use any interpreter for your custom command scripts

```python
#!/usr/bin/python
print "Custom python command!"
```

## More examples

[phpcs custom command](../examples/.drude/commands)
