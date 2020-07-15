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

### With Losing Current Containers and Their Data

Involves removing current VM. Your files will not be deleted, but databases will need to be re-imported, containers' images will be re-downloaded.

1. `fin vm remove`
2. `VBOX_HDD=80000 fin system start`

`VBOX_HDD` is disk size in Megabytes. Default is `50000`.

### Without Losing Current Containers and Data

There is no good way to automate this.

[Follow this instruction to perform it manually](https://www.jeffgeerling.com/blogs/jeff-geerling/resizing-virtualbox-disk-image).

## Free Up Space in VirtualBox VM, Docker for Mac, or Docker for Windows

If you are looking to free up some space that is already used, rather than resizing the virtual disk,
then here are some steps that you can take:

1. Running `fin cleanup` is the easiest easiest way to free space. This will clear out any containers of projects that no
longer exists on your computer. 

1. The next step would be to look for old projects that do exist, but you may not be working on. Run `fin project list --all`
and look for old, unused projects. You can remove their containers by going to the project directory and running `fin project remove`.

1. You can go even further and delete unused images. Run `fin docker images`, investigate the list of images for unused,
outdated or temporary ones, and remove them with `fin docker image remove <name or id>`.

	Navigating output of the Docker command above might be challenging, so `fin` can provide a helping hand.

		fin cleanup --images

	This command will run a Docker Images cleanup Wizard, that will help you to navigate image list and delete unused one by one.
	And don't worry, if the image is still used by an existing container it will not get deleted even if you reply yes.

	Removing unused images might be able to free up gigabytes of space.
