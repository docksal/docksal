---
title: "fin"
weight: 1
---

Docksal Fin (`fin`) is a command line tool for controlling a Docksal.  
`fin` runs natively on Mac and Linux. Windows users have to use [Babun](http://babun.github.io) shell to run `fin`.


## Using fin

To list available commands, either run `fin` with no parameters or `fin help`.





Complex management commands have their own help sections, e.g. `fin help db`

For a complete list of `fin help` topics see [fin-help](../fin/fin-help.md)


## Custom commands

Fin can be extended with project level [custom commands](../fin/custom-commands.md) written in any script language.

If a projects has custom commands defined, they will show up at the bottom of `fin help`:

    $ fin help
    ...
    Custom commands found in project commands:
        init                          Initialize a Docksal powered Drupal 8 site
