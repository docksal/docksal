# DSH custom commands

Extending DSH with your custom commands is supported in DSH 1.17+

1. Creating a command

    Example: `.drude/commands/updb` (Notice no extension. Script name should match command name)

    ```bash
    #!/bin/bash
    dsh drush updb $1
    ```

2. Set executable bit `chmod +x .drude/commands/updb`

## Using a command

Use as regular dsh command: `dsh updb`

Parameters passing also works: `dsh updb -y`

## Advanced use

It is not imperative to use bash. You can use any interpreter for your custom command scripts

```python
#!/usr/bin/python
print "Custom python command!"
```
