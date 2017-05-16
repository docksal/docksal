# Docksal VirtualBox VM configuration

These instructions are only applicable to macOS and Windows.

## Increasing Docksal's Virtualbox VM memory (RAM)

`fin vm ram` - will show the current memory size

`fin vm ram 2048` - will set the vm memory to 2048MB

## Increasing Docksal's Virtualbox VM disk size (HDD)

### With losing current containers and their data

Involves removing current VM. Your files will not be deleted but databases will need to be re-imported, containers' images will be re-downloaded.

1. `fin vm remove`
2. `VBOX_HDD=80000 fin vm start`

`VBOX_HDD` is disk size in Megabytes. Default is `50000`.

### Without losing current containers and data

There is no good way to automate this.

Follow this instruction to perform it manually: https://www.jeffgeerling.com/blogs/jeff-geerling/resizing-virtualbox-disk-image
