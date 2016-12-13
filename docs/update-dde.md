# Updating from Drude (DDE) to Docksal

Drude used to rely on Vagrant and vagrant-boot2docker for running Docker.
Docksal uses Docker Machine, which is more native and supports seamless (non-destructive) Docker version updates.
Drude's Vagrant machine is not going to be used anymore and should be deleted (follow instructions below).

## Create backups

Create dumps of databases that you need with `drush`

## Remove old VM

```
vagrant destroy
```

This command will remove the old Drude VM

Go to your Drude projects folder (the one with `Vagrantfile` and `vagrant.yml`) and use `vagrant destroy` to destroy the Drude VM.
If you happened to have several of them, please destroy all.

It is very important to use `vagrant destroy` and not delete the VM manually in VirtualBox.
Vagrant has to clean things up properly and that is what `vagrant destroy` is for.

## Uninstall vagrant

Uninstall vagrant if you do not plan to use it for other purposes

Depending on how Vagrant was installed you will either have to uninstall it manually or
via `brew uninstall vagrant` on Mac / `choco uninstall vagrant` on Windows

## Install Docksal

[Docksal environment setup](env-setup.md)
