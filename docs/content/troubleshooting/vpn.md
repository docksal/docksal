---
title: "Using Docksal with VPNs"
weight: 2
---

{{% notice warning %}}
The approach described here is only possible with Docker Desktop (Mac and Windows). It won't work when using 
Docksal with VirtualBox on Mac/Windows, nor will it help on Linux.
{{% /notice %}}

Some VPNs are configured to intercept and re-route all traffic (let's call them "greedy"), thus breaking 
access to the `192.168.64.100` IP that Docksal is using. Attempting to change network routing while connected to
a greedy VPN will usually result in VPN dropping the connection. Enterprise security at work here.

The one thing VPNs cannot do though, is mess with the hosts loopback interface (`127.0.0.1`). That's how your 
traditional web server is not affected by a greedy VPN connection - it just binds to `127.0.0.1:80` (or more 
likely to `0.0.0.0:80` - port `80` on all network interfaces).

Binding to `0.0.0.0:80` can be achieved with Docksal like this:

```
fin config set --global DOCKSAL_VHOST_PROXY_IP=0.0.0.0
fin system reset vhost-proxy
```

You can then access `http://localhost` (or `https://127.0.0.1`) and see the "Project missing" page from Docksal's
vhost-proxy container.

Now, how do you get `http://myproject.docksal` working in this setup? `<anything>.docksal` resolves to `192.168.64.100` 
by default, which won't work while connected to a greedy VPN.

For now, you will have to manually add an DNS override in your hosts file, e.g.:

```
127.0.0.1 myproject.docksal
```

Test it with a ping:

```
$ ping myproject.docksal
PING myproject.docksal (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.048 ms
```
