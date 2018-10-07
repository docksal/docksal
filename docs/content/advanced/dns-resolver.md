---
title: "DNS resolver"
---


Docksal runs a system service called `docksal-dns`.

This service is responsible for the wildcard `*.docksal` domain resolution to the Docksal IP (`192.168.64.100`).  
It also forwards all other DNS requests to the upstream DNS server, which is Google's Public DNS (`8.8.8.8`) by default. 

Project containers are configured to use `docksal-dns` as their DNS server by default.

Docksal configures network settings on Linux, Mac, and Windows to tell the host machine to use `docksal-dns` as well.

On Mac only `*.docksal` DNS queries are routed through `docksal-dns`.

On Linux and Windows DNS, all DNS queries are routed through `docksal-dns`, as there is no way to configure this 
selectively (like on Mac). 

In cases when the Docksal VM is stopped or the `docksal-dns` service is down, the OS picks the next available DNS server 
configured on the host (which would be your LAN/WiFi connection). This way there is always a fallback.


## Disabling the resolver

If you run into issues with DNS resolution, try disabling the automatic resolver.

1. Stop the VM with `fin vm stop`
2. Open `$HOME/.docksal/docksal.env` and add `DOCKSAL_NO_DNS_RESOLVER=true`
3. Start the VM again `fin vm start`   

Without the automatic resolver, you can use `fin hosts` command to manage name resolution via the `hosts` file.


## Override the default upstream DNS settings

Some restricted network environments (e.g., corporate networks) may be blocking direct access to external DNS services, 
making `8.8.8.8` inaccessible. In such cases, Docksal will output a warning on `fin project start` with the instructions to override the default upstream DNS settings.

1. Open `$HOME/.docksal/docksal.env` and set `DOCKSAL_DNS_UPSTREAM` to your local network DNS server

    Example:
    
    ```
    DOCKSAL_DNS_UPSTREAM=192.168.0.1
    ```

2. Run `fin system reset dns`

Inspect your LAN or WiFi interface settings and connection status to figure out the DNS server your network is using.


## Enable DNS query logging (for debugging) 

Enable logging

```
DOCKSAL_DNS_DEBUG=true fin system reset dns
```

View logs

```
fin docker logs docksal-dns
```
