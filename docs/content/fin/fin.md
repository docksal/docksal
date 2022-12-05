---
title: "fin"
weight: 1
aliases:
  - /en/master/fin/fin/
---

Docksal Fin (`fin`) is a command line tool for controlling Docksal.  
`fin` runs natively on Mac and Linux. Windows users have to use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/faq) shell to run `fin`.


## Using fin

To list available commands, either run `fin` with no parameters or `fin help`.


Complex management commands have their own help sections, e.g., `fin help db`

For a complete list of `fin help` topics see [fin-help](/fin/fin-help/)


## Custom Commands

Fin can be extended with project level [custom commands](/fin/custom-commands/) written in any script language.

If a projects has custom commands defined, they will show up at the bottom of `fin help`:

    $ fin help
    ...
    Custom commands found in project commands:
        init                          Initialize a Docksal powered Drupal 8 site

## Using Integrated Tools

There are several [tools](/tools/) pre-installed in the cli container. Some of those tools are aliased as 
"top level" tools and can be used by running `fin` and the tool name such as drush or composer. Other tools
will require that you use the `exec` command to run them on-demand. Some commands that you might run:

```bash
    fin exec python3 --version
    fin exec npm install
```