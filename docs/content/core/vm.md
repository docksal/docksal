---
title: "VirtualBox VM"
weight: 3
aliases:
  - /en/master/advanced/vm/
---


These instructions are only applicable to macOS and Windows.

## Set Docksal's Virtualbox VM Memory (RAM)

`fin vm ram` - will show the current memory size

For hosts with limited RAM (less than 8GB) it may be necessary to limit the VM memory to 1GB:

`fin vm ram 1024` - will set the VM memory to 1024MB

1GB of RAM provides enough memory to run 2 basic LAMP stacks at the same time.

When working with multiple projects, it is best to limit the number of active projects to 1 or 2. 
Trying to launch more than 2 at the same time may result in unpredictable issues.

Use `fin stop --all` to stop all projects, then `fin project start` to restart the one you plan to work with.

## Increasing Docksal's VirtualBox VM Disk Size (HDD)

### With losing current containers and their data

Involves removing current VM. Your files will not be deleted, but databases will need to be re-imported, containers' images will be re-downloaded.

1. `fin vm remove`
2. `VBOX_HDD=80000 fin vm start`

`VBOX_HDD` is disk size in Megabytes. Default is `50000`.

### Without losing current containers and data

There is no good way to automate this.

[Follow this instruction to perform it manually](https://www.jeffgeerling.com/blogs/jeff-geerling/resizing-virtualbox-disk-image).

## Free Up Space in VirtualBox VM

If you're not looking to increase the actual disk space allocated to VirtualBox but free up the space that is already used,
here are some steps you can take:

Running `fin cleanup` is the easiest easiest way to clear space. This will clear out any containers of projects that no
longer exists on your computer. 

The next step would be to to look for old projects that do exist but you may not be working on. Run `fin project list --all` 
and see the old, unused projects. You can remove the containers by going to the project directory and running `fin project remove`l
