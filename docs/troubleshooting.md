## Failed creating Docksal virtual machine

Mostly on Windows 7 but sometimes on other OS-s VirtualBox fails to create new virtual machine on the first run. Errors might be very different but usually simply removing failed machine and trying again helps.

```
fin vm remove
fin vm start
```

## Error checking TLS connection (vm is not accessible)

```
Error checking TLS connection: Error checking and/or regenerating the certs: There was an error validating certificates for host "192.168.64.100:2376": dial tcp 192.168.64.100:2376: getsockopt: connection refused
You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
Be advised that this will trigger a Docker daemon restart which will stop running containers.
```

#### Explanation

Sometimes docker-machine certificaties re-generation fails. 

#### Solution
Usually it is solved with `fin vm restart`.

However in rare cases this does not help. We advice trying to restart your host OS first.
If that does not help either you will have to delete existing Docksal VM and re-create it.

1. `fin vm remove`
2. `fin vm start`


## Lack of memory

Composer on Drupal 8 projects might spawn this error:

```
The following exception is caused by a lack of memory and not having swap configured
Check https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors for details
```

#### Explanation

Default Docksal virtual machine features 1GB (1024MB) of RAM. Drupal 8 tools sometimes require more that that.

#### Solution

Set bigger amount of RAM. For instance 2048 Mb
```
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

#### Explanation: a single directory can only be exported once. 
It can not be exported several times with different settings.
   
#### Solution
   
1) Remove conflicting export from `/etc/exports` (remove the one which is non-docksal) and save the file.  
2) `fin vm restart`

## Config permissions issue (vm does not start)

```
open /Users/John.Doe/.docker/machine/machines/docksal/config.json: permission denied
```

####  Explanation
You have created Docksal machine as root user (maybe using sudo). 
This is not recommended in particular because of problems like this.

#### Solution
Re-create vm as a regular user

1. `sudo fin vm remove`
2. `fin vm start`

## Multiple host-only adapters (vm is not created)

```
Error with pre-create check: "VirtualBox is configured with multiple host-only adapters with the same IP \"192.168.64.1\". Please remove one."
```

1. Open VirtulBox UI
2. Open Preferences > Network tab
3. Click "Host-only Netwirks" tab
4. Click through adapters in list and delete the ones with `192.168.64.1` IP
