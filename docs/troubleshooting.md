# Troubleshooting

Below is a list of known rare issues and ways to resolve them.

## Failed creating Docksal virtual machine

Mostly on Windows 7, but sometimes on other OS-s, VirtualBox fails to create a new virtual machine on the first run. 
Errors might vary. Removing the failed machine and trying again usually helps.

```bash
fin vm remove
fin vm start
```

## Error checking TLS connection (vm is not accessible)

```
Error checking TLS connection: Error checking and/or regenerating the certs: There was an error validating certificates for host "192.168.64.100:2376": dial tcp 192.168.64.100:2376: getsockopt: connection refused
You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
Be advised that this will trigger a Docker daemon restart which will stop running containers.
```

Sometimes docker-machine certificates re-generation fails. This usually can be resolved with `fin vm restart`.

If a restart does not help try

```bash
fin docker-machine regenerate-certs docksal -f
fin vm restart
```

However in rare cases this may not help ether and the only solution would be to delete the existing Docksal VM and re-create it.

```bash
fin vm remove
fin vm start
```


## Lack of memory

Composer on Drupal 8 projects might spawn this error:

```
The following exception is caused by a lack of memory and not having swap configured
Check https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors for details
```

By default, a Docksal virtual machine is provisioned with 1GB (1024MB) of RAM. Drupal 8 tools sometimes require more that that.

Set a bigger amount of RAM for the VM, e.g. 2048 Mb

```bash
fin vm ram 2048
```

## Conflicting exports (files are not accessible)

```
 ERROR:  conflicting exports for /Users, 192.168.64.100
exports:11: export option conflict for /Users
-----------------
/Users 192.168.64.100 -alldirs -mapall=0:0
# <ds-nfs docksal
/Users 192.168.64.100 -alldirs -mapall=501:20
# ds-nfs>
```

With NFS a single directory can only be exported once. It can not be exported several times with different settings.
   
Remove the conflicting export from `/etc/exports` (remove the non-docksal one), save the file, then run `fin vm restart`.

## Conflicting ports

```
Resetting Docksal services...
 * proxy
docker: Error response from daemon: driver failed programming external connectivity
on endpoint docksal-vhost-proxy (a7addf7797e6b0aec8e3e810c11775eb77508c9079e375c083b3650df2dff9a2):
Error starting userland proxy: listen tcp 0.0.0.0:443: listen: address already in use.
```

This usually happens on Linux because the default Apache server bind to `0.0.0.0:80` and `0.0.0.0:443` (all IPs).  
This prevents Docksal from running properly.

You either need to stop Apache or reconfigure it to listen on different ports (e.g. `8080` and `4433`) or
different/specific IPs (e.g. `127.0.0.1:80` and `127.0.0.1:443`).


## Config permissions issue (vm does not start)

```
open /Users/John.Doe/.docker/machine/machines/docksal/config.json: permission denied
```

You careated the Docksal VM as the root user (probably using `sudo`).  
This is not recommended in particular because of the problems like this.

Re-create vm as a regular user

```bash
sudo fin vm remove
fin vm start
```

## Multiple host-only adapters (vm is not created)

```
Error with pre-create check: "VirtualBox is configured with multiple host-only adapters with the same IP \"192.168.64.1\". Please remove one."
```

1. Open VirtulBox UI
2. Open Preferences > Network tab
3. Click "Host-only Networks" tab
4. Click through adapters in list and delete the ones with the `192.168.64.1` IP
