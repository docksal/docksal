# Troubleshooting. Some common problems using Docksal and ways to resolve them.

## Issue 1. Failed creating Docksal virtual machine on Windows

```
...
(docksal) Downloading C:\Users\alex\.docker\machine\cache\boot2docker.iso from https://github.com/boot2docker/boot2docker/releases/download/v17.04.0-ce/boot2docker.iso...
(docksal) 0%....10%....20%....30%....40%....50%....60%....70%....80%....90%....100%
(docksal) Creating VirtualBox VM...
(docksal) Creating SSH key...
Wrapper Docker Machine process exiting due to closed plugin server (read tcp 127.0.0.1:49393->127.0.0.1:49392: wsarecv: An existing connection was forcibly closed by the remote host.)
Error creating machine: Error in driver during machine creation: read tcp 127.0.0.1:49393->127.0.0.1:49392: wsarecv: An existing connection was forcibly closed by the remote host.
 ERROR:  Proper creation of virtual machine has failed
         For details please refer to the log above.
         It is recommended to remove malfunctioned virtual machine.
Remove docksal? [y/n]:
```

If you see this error then most likely you had just installed Virtual Box.
Sometimes Virtual Box fails to initialize it's network interfaces properly.

### How to resolve

1. Reply yes to remove malfunctioned virtual machine.
2. Reboot your local host and try again.

## Issue 2. Error checking TLS connection (vm is not accessible)

```
Error checking TLS connection: Error checking and/or regenerating the certs: There was an error validating certificates for host "192.168.64.100:2376": dial tcp 192.168.64.100:2376: getsockopt: connection refused
You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
Be advised that this will trigger a Docker daemon restart which will stop running containers.
```

Sometimes docker-machine certificates re-generation fails.

### How to resolve

1. Perform `fin vm restart`.
2. If above did not help, then reboot your local host.
3. If above did not help, perform commands below and then reboot your host:

```bash
fin docker-machine regenerate-certs docksal -f
fin vm restart
```

4. In the rare cases when above did not help the only solution is to delete the existing VM and re-create it.

```bash
fin vm remove
fin vm start
```


## Issue 3. Lack of memory

Composer on Drupal 8 projects might spawn this error:

```
The following exception is caused by a lack of memory and not having swap configured
Check https://getcomposer.org/doc/articles/troubleshooting.md#proc-open-fork-failed-errors for details
```

By default, a Docksal virtual machine is provisioned with 2GB (2048MB) of RAM. This should be enough for a decent size 
Drupal 8 project and composer.

### How to resolve

1. If the VM keeps running out of memory or you are getting weird issue with the `db` (or other) services failing, then
try stopping all active projects (`fin stop --all`) and only start the one you need.

2. Alternatively give the VM more RAM (e.g. 4096 MB). This may only be necessary when running several very heavy
stacks/projects at the same time.

```bash
fin vm ram 4096
```

## Issue 4. Conflicting NFS exports (files are not accessible)

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

### How to resolve

Remove the conflicting export from `/etc/exports` (remove the non-docksal one), save the file, and run `fin vm restart` or `fin vm start` again.

## Issue 5. Conflicting ports

```
Resetting Docksal services...
 * proxy
docker: Error response from daemon: driver failed programming external connectivity
on endpoint docksal-vhost-proxy (a7addf7797e6b0aec8e3e810c11775eb77508c9079e375c083b3650df2dff9a2):
Error starting userland proxy: listen tcp 0.0.0.0:443: listen: address already in use.
```

This usually happens on Linux because the default Apache server bind to `0.0.0.0:80` and `0.0.0.0:443` (all IPs).  
This prevents Docksal from running properly.

### How to resolve

1. Stop Apache or
2. Reconfigure Apache to listen on different ports (e.g. `8080` and `4433`) or
different/specific IPs (e.g. `127.0.0.1:80` and `127.0.0.1:443`).

## Issue 6. Config permissions issue (vm does not start)

```
open /Users/John.Doe/.docker/machine/machines/docksal/config.json: permission denied
```

You created the Docksal VM as the root user (probably using `sudo`).
This is not recommended in particular because of the problems like this.

### How to resolve

Re-create vm as a regular user

```bash
sudo fin vm remove
fin vm start
```

## Issue 7. Multiple host-only adapters (vm is not created)

```
Error with pre-create check: "VirtualBox is configured with multiple host-only adapters with the same IP \"192.168.64.1\". Please remove one."
```

### How to resolve

1. Open VirtualBox UI
2. Open Preferences > Network tab
3. Click "Host-only Networks" tab
4. Click through adapters in list and delete the ones with the `192.168.64.1` IP

## Issue 8. DNS server misbehaving

```
ERROR: error pulling image configuration: Get https://dseasb33srnrn.cloudfront.net/registry-v2/docker/registry/v2/blobs/sha256/9f/9fb8c0aed5fc7cc710884dc9cbd0974cc606053989b4f73f20e8b363e7d6cc7f/data?Expires=1490711517&Signature=SzvWOicPa6yZRxlBh1~vsl2xHtkOXR8xDj~usSP8aS9ZFhNQ8oH5pAcfZyx3sxgPgtqPgSOzuoaBtw5lT0~i0mpt~QCBpkgRhgyRQ8rzkbI1sG9ZRDXvRQ4sG49ckorbHyUT8isG5mEWl3Ar8kateU9he9fdlRhe5V5Zvn-et0s_&Key-Pair-Id=APKAJECH5M7VWIS5YZ6Q: dial tcp: lookup dseasb33srnrn.cloudfront.net on 10.0.2.3:53: server misbehaving
```

```
Pulling db (docksal/db:1.1-mysql-5.6)...
ERROR: Get https://registry-1.docker.io/v2/: dial tcp: lookup registry-1.docker.io on 10.0.2.3:53: server misbehaving
```

Your system DNS server does not properly resolve `index.docker.io`.

### How to resolve

Use [Google Public DNS server](https://developers.google.com/speed/public-dns/) or [Open DNS](https://www.opendns.com/setupguide/).

1. Please [refer to the doc on how to apply DNS](https://developers.google.com/speed/public-dns/docs/using) on your operating system.
2. `fin vm restart` after you apply your new DNS settings.

macOS DNS settings example:

![macOS DNS settings](_img/troubleshooting-network-dns.png)

## Issue 9. FastCGI: incomplete headers

```
web_1        | [Wed Apr 19 14:57:37 2017] [error] [client 172.19.0.6] (111)Connection refused: FastCGI: failed to connect to server "/usr/lib/cgi-bin/php5-fcgi": connect() failed
web_1        | [Wed Apr 19 14:57:37 2017] [error] [client 172.19.0.6] FastCGI: incomplete headers (0 bytes) received from server "/usr/lib/cgi-bin/php5-fcgi"
web_1        | 172.19.0.6 - - [19/Apr/2017:14:57:37 +0000] "GET / HTTP/1.1" 500 639 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36"
```

Errors like this appear when your Apache is misconfigured. Most often it happens because of misconfigured environment variables in `docksal.yml`. Sometimes it can be misconfiguration in `.htaccess`.

### How to resolve

Check `docksal.yml` and `.htaccess` files for configuration errors, fix them and run `fin project start` (`fin start` for short).

## Issue 10. SMB share creation, share mounting and related issues on Windows

Please see a separate [troubleshooting document on share creation, share mounting and related issues](troubleshooting-smb.md).

## Issue 11. Common MySQL related issues

```
ERROR 2003 (HY000): Can't connect to MySQL server on 'db' (111)
```

There may be many different errors. Check Mysql logs with `fin logs db` for details.
Here we will just look at the most common case.

If you see error like:

```
db_1   | 170614 14:26:54 [Note] Plugin 'FEDERATED' is disabled.
db_1   | 170614 14:26:54 InnoDB: The InnoDB memory heap is disabled
db_1   | 170614 14:26:54 InnoDB: Mutexes and rw_locks use GCC atomic builtins
db_1   | 170614 14:26:54 InnoDB: Compressed tables use zlib 1.2.3
db_1   | 170614 14:26:54 InnoDB: Using Linux native AIO
db_1   | 170614 14:26:54 InnoDB: Initializing buffer pool, size = 256.0M
db_1   | InnoDB: mmap(274726912 bytes) failed; errno 12
db_1   | 170614 14:26:54 InnoDB: Completed initialization of buffer pool
db_1   | 170614 14:26:54 InnoDB: Fatal error: cannot allocate memory for the buffer pool
db_1   | 170614 14:26:54 [ERROR] Plugin 'InnoDB' init function returned error.
db_1   | 170614 14:26:54 [ERROR] Plugin 'InnoDB' registration as a STORAGE ENGINE failed.
db_1   | 170614 14:26:54 [ERROR] Unknown/unsupported storage engine: InnoDB
db_1   | 170614 14:26:54 [ERROR] Aborting
db_1   |
db_1   | 170614 14:26:54 [Note] mysqld: Shutdown complete
```

Then `cannot allocate memory for the buffer pool` means you don't have enough of free memory on your Docksal VM 
to run the project.

### How to resolve

See Issue 3. Lack of memory for resolution.
