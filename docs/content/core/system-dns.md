---
title: "System: DNS Resolver"
weight: 2
aliases:
  - /en/master/advanced/dns-resolver/
---


Docksal runs a system service called `docksal-dns`.

This service is responsible for the wildcard `*.docksal` domain resolution to the Docksal IP (`192.168.64.100`).  
It also forwards all other DNS requests to the upstream DNS server, which is Google's Public DNS (`8.8.8.8`) by default. 

Project containers are configured to use `docksal-dns` as their DNS server by default. 
Docksal also configures network settings on Linux, Mac, and Windows to tell the host machine to use `docksal-dns` as well.

On Mac, only `*.docksal` DNS queries are routed through `docksal-dns`. 

On Linux and Windows DNS, all DNS queries are routed through `docksal-dns`, as there is no way to configure this 
selectively (like on Mac). In cases when the Docksal VM is stopped or the `docksal-dns` service is down, the OS picks 
the next available DNS server configured on the host (which would be your LAN/WiFi connection). This way, there is 
always a fallback.


## Disabling the Resolver {#disable}

If you run into issues with DNS resolution on the host machine, try disabling the built-in DNS resolver:

```bash
fin config set --global DOCKSAL_DNS_DISABLED=1
fin system reset
```

See [DOCKSAL_DNS_DISABLED](/stack/configuration-variables/#docksal-dns-disabled) variable docs for more information.

You can also [manually manage](#manual) custom DNS records.


## Managing DNS Manually {#manual} 

There are a few cases when you may have to manage DNS resolution manually:

- Docksal built-in DNS resolver has been [disabled](#disable)
- The host is not connected to a WiFi/LAN network
- You are using a custom domain for your project (e.g., local.example.com)

In such cases, you will have to configure the host and container DNS resolution manually.

### Host DNS Resolution

Host DNS resolution can be overridden using the OS `hosts` file. Docksal provides a command to simplify the management 
of this file - [fin hosts](/fin/fin-help/#hosts).

To add a custom domain to the `hosts` file, run:

```bash
fin hosts add local.example.com
```

### Container DNS Resolution

To have your project containers resolve a custom DNS record, you can use the docker-compose 
[extra_hosts](https://docs.docker.com/compose/compose-file/compose-file-v2/#extra_hosts) parameter.   

Add this parameter in the project's `docksal.yml` to any container, where you want your custom DNS records to work:

```yaml
version: "2.1"

services:
  cli:
    extra_hosts:
      - "www.example.com:127.0.0.1"
      - "example.com:127.0.0.1"
```

In the example above, we added two extra hosts to the `cli` service.

{{% notice warning %}}
It is not possible to define wildcard DNS records using the manual approach (host and containers). You will have to 
add multiple individual records.
{{% /notice %}}


## Override the Default Upstream DNS Settings

Some restricted network environments (e.g., corporate networks) may be blocking direct access to external DNS services, 
making `8.8.8.8` inaccessible. In such cases, Docksal will output a warning on `fin project start` with instructions 
to override the default upstream DNS settings.

To override the upstream DNS server settings:

```bash
fin config set --global DOCKSAL_DNS_UPSTREAM=<dns-server-ip>
fin system reset dns
```

Inspect your LAN or WiFi interface settings and connection status to figure out the DNS server your network is using.


## Enable DNS Query Logging (for debugging) 

```bash
# Enable logging
DOCKSAL_DNS_DEBUG=true fin system reset dns

# View logs
fin docker logs docksal-dns
```
