---
title: "Cloudflare Tunnel"
---


In certain cases you may want to share or expose you local web server on the internet (e.g., share access with a teammate or customer to demonstrate the work or discuss the progress). Working with external web services that expect a callback URL is also generally not possible with a local environment.


## cloudflared

[cloudflared](https://developers.cloudflare.com/cloudflare-one/tutorials/share-new-site/) creates a tunnel from 
the public internet to a port on your local machine. You can share the URL with anyone to give them access to 
your local development environment.


## Usage

Inside the project folder run:

```bash
fin share-v2 start
```

The public URL will be output.

To stop sharing:

```bash
fin share-v2 stop
```

To get the status and print the public URL:

```bash
fin share-v2 status
```

To simply print the public URL:

```bash
fin share-v2 url
``` 
