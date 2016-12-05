# Working with multiple projects

Docksal has a built-in reverse proxy container that adds support for running multiple projects. The container binds to `192.168.64.100:80` and routes web requests based on the host name.

## Setting up. MacOS and Linux
On Mac OS and Linux you don't need to do anything. Routing is automatically configured upon first `fin update`. 

## Setting up. Windows
On Windows you will need to manually append virtual host of each of your Doskal projects to the [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)) to route it to `192.168.64.100`.

Example [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)):
```
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.

drupal7.docksal    192.168.64.100
myproject.docksal    192.168.64.100
```
## Finding out project hostname

To find current project's virtual host name run `fin config | grep ^VIRTUAL_HOST`

```
$ fin config | grep ^VIRTUAL_HOST
VIRTUAL_HOST: netscout.docksal
```

> Hint: hostname is usually a project's folder name sans spaces and dashes
