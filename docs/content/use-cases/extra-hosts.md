---
title: "Add Hosts Records"
weight: 1
---

To add a host record inside of your container so that it will be able to resolve arbitrary domains, configure your 
`docksal.yml` file with the following:

```yaml
version: "2.1"

services:
  # CLI
  cli:
    extra_hosts:
      - "www.example.com:127.0.0.1"
      - "example.com:127.0.0.1"
```
