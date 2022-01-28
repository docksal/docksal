---
title: "Common Issues"
weight: 1
aliases:
  - /en/master/troubleshooting/
---

{{% notice warning %}}
Quite often a problem may reside within the 3rd party tools, project code, local configuration, etc., and not the stack.
To make sure that the Docksal stack works properly, try launching any of the [sample projects](https://github.com/docksal?q=boilerplate).  
If you believe the issue is within the Docksal stack, then read on.
{{% /notice %}}

First, try these quick fix steps in the order listed below. Check if the issue has cleared out **after each step**.

- Update Docksal to the latest version. See the [updates](/getting-started/setup/#updates) section.
- (Only if you use VirtualBox) Restart the Docksal VM: `fin vm restart`
- Reset Docksal system services with `fin system reset` and restart project containers with `fin project restart`
- Reboot the host (your computer or remote server)

If that did not help, take a look at some of the common problems using Docksal and ways to resolve them below.

If above did not help, try:

- searching the [GitHub issue queue](https://github.com/docksal/docksal/issues). Others may have experienced a similar issue and already found a solution or a workaround.
- asking community for support in [Discussions](https://github.com/docksal/docksal/discussions) on GitHub
- creating a [new issue](https://github.com/docksal/docksal/issues/new) if your problem is still not resolved.

-----

## Issue 1. Failed Creating Docksal Virtual Machine on Windows {#issue-01}

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

If you see this error, most likely you had just installed Virtual Box.
Sometimes Virtual Box fails to initialize its network interfaces properly.

### How to Resolve

1. Reply `yes` to remove malfunctioned virtual machine.
2. Reboot your local host and try again.


## Issue 2. Error checking TLS Connection (VM is not accessible) {#issue-02}

There can be two very similar errors starting with "Error checking TLS connection" and ending with:

- "getsockopt: connection refused"

    ```
    Error checking TLS connection: Error checking and/or regenerating the certs: There was an error validating certificates for host "192.168.64.100:2376": dial tcp 192.168.64.100:2376: getsockopt: connection refused
    You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
    Be advised that this will trigger a Docker daemon restart which will stop running containers.
    ```

- "x509: certificate has expired or is not yet valid"

    ```
    Error checking TLS connection: Error checking and/or regenerating the certs: There was an error validating certificates for host "192.168.64.100:2376": x509: certificate has expired or is not yet valid
    You can attempt to regenerate them using 'docker-machine regenerate-certs [name]'.
    Be advised that this will trigger a Docker daemon restart which might stop running containers.
    ```

#### How to Resolve

1. Run the following command:

	```bash
	fin docker-machine regenerate-certs --client-certs --force docksal
	fin vm restart
	```

    For reference: https://docs.docker.com/machine/reference/regenerate-certs/

2. Verify the docksal VM starts and that you can start your projects.

In the rare cases when above did not help, the only solution is to delete the existing VM and re-create it:

```bash
fin vm remove
fin system start
```


## Issue 3. Out-of-memory Issues {#issue-03}

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

2. Alternatively give the VM more RAM (e.g., 4096 MB). This may only be necessary when running several very heavy
stacks/projects at the same time.

```bash
fin vm ram 4096
```


## Issue 4. Conflicting NFS Exports (files are not accessible) {#issue-04}

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

### How to Resolve

Remove the conflicting export from `/etc/exports` (remove the non-docksal one), save the file, and run `fin vm restart` or `fin system start` again.


## Issue 5. Conflicting Ports {#issue-05}

### Symptoms

If a port is currently in use or if your computer has ever been configured to forward ports
locally for development, you may receive one of these errors:

```
Resetting Docksal services...
 * proxy
docker: Error response from daemon: driver failed programming external connectivity
on endpoint docksal-vhost-proxy (a7addf7797e6b0aec8e3e810c11775eb77508c9079e375c083b3650df2dff9a2):
Error starting userland proxy: listen tcp 0.0.0.0:443: listen: address already in use.
```

```
docker: Error response from daemon: Ports are not available: listen udp 0.0.0.0:53: bind: address already in use.
 ERROR:  Failed starting the DNS service.
```

```
docker: Error response from daemon: Ports are not available: listen tcp 0.0.0.0:80: bind: address already in use.
 ERROR:  Failed starting the Failed starting the proxy service.
```

```
docker: Error response from daemon: Ports are not available: listen tcp 0.0.0.0:443: bind: address already in use.
 ERROR:  Failed starting the Failed starting the proxy service.
```

This usually happens on Linux because the default Apache server bind to `0.0.0.0:80` and `0.0.0.0:443` (all IPs).  
This prevents Docksal from running properly.

### How to Resolve

#### macOS

UDP/53

Port 53 will likely be used by a local dnsmasq instance. You may not even remember installing it.

Check which process uses UDP port 53:

```
$ netstat -vanp udp | awk '$4 ~ /\.53$/' | awk '{print $8}' | xargs ps -p
  PID TTY           TIME CMD
  140 ??         0:00.01 /usr/local/opt/dnsmasq/sbin/dnsmasq --keep-in-foreground -C /usr/local/etc/dnsmasq.conf
```

See the instructions to [install/uninstall dnsmasq](https://gist.github.com/valentinocossar/c92abb39ffa0ba1eaf08466e35b85d11).

TCP/80 and TCP/443

Ports 80/443 are web server ports and will likely be used by a local Apache/etc. instance:

Check which process uses TCP ports 80/443

```
$ netstat -vanp tcp | awk '$4 ~ /\.80$/' | awk '{print $9}' | xargs ps -p
$ netstat -vanp tcp | awk '$4 ~ /\.443$/' | awk '{print $9}' | xargs ps -p
```

#### Linux

1. Stop Apache or
2. Reconfigure Apache to listen on different ports (e.g., `8080` and `4433`) or
different/specific IPs (e.g., `127.0.0.1:80` and `127.0.0.1:443`)

#### Windows

To check which process uses TCP ports 80/443, run the following in a powershell window:

```
Get-Process -Id (Get-NetTCPConnection -LocalPort 80).OwningProcess
Get-Process -Id (Get-NetTCPConnection -LocalPort 443).OwningProcess
```

## Issue 6. Config Permissions Issue (VM does not start) {#issue-06}

```
open /Users/John.Doe/.docker/machine/machines/docksal/config.json: permission denied
```

You created the Docksal VM as the root user (probably using `sudo`).
This is not recommended in particular because of the problems like this.

### How to Resolve

Re-create vm as a regular user

```bash
sudo fin vm remove
fin system start
```


## Issue 7. Multiple Host-only Adapters (VM is not created) {#issue-07}

```
Error with pre-create check: "VirtualBox is configured with multiple host-only adapters with the same IP \"192.168.64.1\". Please remove one."
```

### How to Resolve

1. Open VirtualBox UI
2. Open Preferences > Network tab
3. Click "Host-only Networks" tab
4. Click through adapters in list and delete the ones with the `192.168.64.1` IP


## Issue 8. DNS Server Misbehaving {#issue-08}

```
ERROR: error pulling image configuration: Get https://dseasb33srnrn.cloudfront.net/registry-v2/docker/registry/v2/blobs/sha256/9f/9fb8c0aed5fc7cc710884dc9cbd0974cc606053989b4f73f20e8b363e7d6cc7f/data?Expires=1490711517&Signature=SzvWOicPa6yZRxlBh1~vsl2xHtkOXR8xDj~usSP8aS9ZFhNQ8oH5pAcfZyx3sxgPgtqPgSOzuoaBtw5lT0~i0mpt~QCBpkgRhgyRQ8rzkbI1sG9ZRDXvRQ4sG49ckorbHyUT8isG5mEWl3Ar8kateU9he9fdlRhe5V5Zvn-et0s_&Key-Pair-Id=APKAJECH5M7VWIS5YZ6Q: dial tcp: lookup dseasb33srnrn.cloudfront.net on 10.0.2.3:53: server misbehaving
```

```
Pulling db (docksal/db:1.1-mysql-5.6)...
ERROR: Get https://registry-1.docker.io/v2/: dial tcp: lookup registry-1.docker.io on 10.0.2.3:53: server misbehaving
```

Your system DNS server does not properly resolve `index.docker.io`.

### How to Resolve

Use [Google Public DNS server](https://developers.google.com/speed/public-dns/) or [Open DNS](https://www.opendns.com/setupguide/).

1. Please [refer to the doc on how to apply DNS](https://developers.google.com/speed/public-dns/docs/using) on your operating system.
2. `fin vm restart` after you apply your new DNS settings.

macOS DNS settings example:

![macOS DNS settings](/images/troubleshooting-network-dns.png)


## Issue 9. FastCGI: Incomplete Headers {#issue-09}

```
web_1        | [Wed Apr 19 14:57:37 2017] [error] [client 172.19.0.6] (111)Connection refused: FastCGI: failed to connect to server "/usr/lib/cgi-bin/php5-fcgi": connect() failed
web_1        | [Wed Apr 19 14:57:37 2017] [error] [client 172.19.0.6] FastCGI: incomplete headers (0 bytes) received from server "/usr/lib/cgi-bin/php5-fcgi"
web_1        | 172.19.0.6 - - [19/Apr/2017:14:57:37 +0000] "GET / HTTP/1.1" 500 639 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36"
```

Errors like this appear when your Apache is misconfigured. Most often it happens because of misconfigured environment variables in `docksal.yml`. Sometimes it can be misconfiguration in `.htaccess`.

### How to Resolve

Check `docksal.yml` and `.htaccess` files for configuration errors, fix them and run `fin project start` (`fin start` for short).


## Issue 10. SMB Share Creation, Share Mounting, and Related Issues on Windows {#issue-10}

Please see a separate [troubleshooting document on share creation, share mounting, and related issues](/troubleshooting/windows-smb/).


## Issue 11. Common MySQL Related Issues {#issue-11}

```
ERROR 2003 (HY000): Can't connect to MySQL server on 'db' (111)
```

There may be many different errors. Check Mysql logs with `fin logs db` for details.
Here we will just look at the most common case.

If you see an error like:

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

### How to Resolve

See Issue 3. Lack of memory for resolution.

## Issue 12. VirtualBox Installation Fails on macOS High Sierra 10.13 {#issue-12}

New Docksal / VirtualBox installations fail on a fresh macOS High Sierra 10.13.x due to the new policy Apple introduced
around third-party kernel extensions.

### How to Resolve

- Open System Preferences > Security & Privacy and click the `Allow` button for `Oracle America, Inc.`
- Restart the VirtualBox installation manually

In certain cases you may have to reboot your Mac and then reinstall VirtualBox manually.

[This video](https://www.youtube.com/watch?v=0vmQOYRCdZM) covers the manual steps necessary to install VirtualBox 
successfully. [See detailed issue resolution](https://github.com/docksal/docksal/issues/417).

## Issue 13. Docker Unauthorized

```text
docker: Error response from daemon: Get https://registry-1.docker.io/v2/docksal/ssh-agent/manifests/1.0: 
unauthorized: incorrect username or password.
See 'docker run --help'.
```

This means that you have docker credentials stored in docker config file, and those credentials are incorrect.

### How to Resolve

See [docker login documentation](https://docs.docker.com/engine/reference/commandline/login/#logging-out) and
to use docker client to either log out or relogin.

## Issue 14. VirtualBox Installation Fails on Windows (Hyper-V Enabled)

Docksal / VirtualBox installations will fail on Windows if Hyper-V is enabled. This will result in a message similar to
below:

```
Error with pre-create check: "This computer is running Hyper-V.
VirtualBox won't boot a 64bits VM when Hyper-V is activated.
Either use Hyper-V as a driver, or disable the Hyper-V hypervisor.
(To skip this check, use --virtualbox-no-vtx-check)
```

To Disable Hyper-V:

* [Run Command Prompt as an Administrator](https://www.howtogeek.com/194041/how-to-open-the-command-prompt-as-administrator-in-windows-8.1/)
* Type the following and press Enter:

```
dism.exe /Online /Disable-Feature:Microsoft-Hyper-V /All
```

## Issue 15. Firewall Blocking Access to Docksal

### On Windows

Visiting the project URL in your browser results in a "site can't be reached" message, could be the result
of a local firewall application blocking access to Docksal's canonical IP address.

Firewall configuration can also cause problems with SMB. See [documentation on troubleshooting Windows SMB](/troubleshooting/windows-smb#smb-ip).

### On Mac

If the containers do not mount properly during system start, you might see an error such as:

```
ERROR: for cli  Cannot create container for service cli: error while mounting volume with options: type='none' device='/Users/alex/Projects/myproject' o='bind': no such file or directory
ERROR: Encountered errors while bringing up the project.
```

### How to Resolve

Configure your firewall to allow connections to and from 192.168.64.100 (Docksal's canonical IP address used across all systems and configurations).

On macOS, go to System Preferences -> Security and Privacy -> Firewall and either turn the Firewall off completely or  
configure it to allow all connections (see image). Then do fin system restart and check if it fixes the issue.

![macOS firewall settings](/images/firewall.png)


## Issue 16. NFS access issues on macOS

Your project's codebase resides under one of the standard user folders in macOS (e.g., Downloads, Documents, 
Desktop) or on an external drive. Project stack does not start and displays an error such as:

```
ERROR:  The path is not accessible in Docker
        Could not access </path/to/project>
        It is not shared from your host to Docker or is restricted.
```


### How to Resolve

Grant **Full Disk Access** privileges  to `/sbin/nfsd`:

- Open **System Preferences**
- Go to **Security & Privacy → Privacy → Full Disk Access**
- 🔒 Click the lock to make changes
- Click **+**
- Press **⌘ command + shift + G**
- Enter `/sbin/nfsd` and click **Go**, then click **Open**

![macOS TCC nfsd](https://user-images.githubusercontent.com/1205005/86679968-f1cc3f80-bfb2-11ea-9a38-44c2f6768c61.png)

Alternatively, you can move the project's codebase out of the restricted user folder (not helpful for external disks).

See [blog post](https://blog.docksal.io/nfs-access-issues-on-macos-10-15-catalina-75cd23606913) for more details.


## Issue 17. Host CPU does not support SSE 4.2 instruction set {#sse4_2}

Symptoms:

- `vhost-proxy` won't start
- `fin docker exet -it docker-vhost-proxy nginx -t` outputs `Illegal instruction (core dumped)`
- Output from `cat /proc/cpuinfo | grep sse4_2` on the host is empty. 

Docksal's [vhost-proxy](/core/system-vhost-proxy) system service uses [OpenResty](https://github.com/openresty/openresty) 
under the hood. The official OpenResty binary packages [require](https://github.com/openresty/openresty/issues/267#issuecomment-309296900) 
SSE4.2 support in the host CPU.

### How to Resolve

As a temporary workaround, vhost-proxy can be downgraded to version 1.2:

```bash
fin config set --global IMAGE_VHOST_PROXY=docksal/vhost-proxy:1.2
fin system reset vhost-proxy
```

{{% notice warning %}}
There is no guarantee that pinning the vhost-proxy image won't result in incompatibility issues with the latest versions of Docksal.
{{% /notice %}}

Long term fix: consider switching to a host with a modern CPU with SSE 4.2 support.

## Issue 18. Composer Out of Memory

Composer 2 is much improved over Composer 1. However, even Composer 2 can throw the dreaded "exhausted memory" or "cannot allocate memory" message.

### How to Resolve

Run your composer command beginning with...

```bash
fin exec COMPOSER_MEMORY_LIMIT=-1 composer
```

If you are still having memory issues, see [Out-of-memory Issues](/troubleshooting/common-issues/#issue-03).

## Issue 19. Out of disk space

Out of disk issues may manifest in many ways. One is:

```
ERROR 1114 (HY000) at line xxxx: The table 'xxxx' is full
```

You can diagnose this issue with `fin exec df -lh`. If a disk shows close to 100% usage, you'll need to either [clean up your projects](https://docs.docksal.io/core/vm/#free-up-space-in-virtualbox-vm-docker-for-mac-or-docker-for-windows) or expand the disk.

### How to Resolve

- [If you are using VirtualBox](https://docs.docksal.io/core/vm/#increasing-docksal-s-virtualbox-vm-disk-size-hdd)
- If you are using Docker Desktop:
  - In the UI, go to Preferences > Resources
  - Increase the "Disk image size"
  - `fin up` to restart your project
