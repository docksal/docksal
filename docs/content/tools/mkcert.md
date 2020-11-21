---
title: "mkcert"

---

# mkcert

[mkcert](https://github.com/FiloSottile/mkcert) is a tool for making locally-trusted HTTPS certificates.

mkcert generated cert will be trusted locally by:

- Firefox (Linux & Mac)
- Chrome & Chromium
- curl & wget

## Setup and Usage (manual/advanced)

Follow [mkcert installation steps](https://github.com/FiloSottile/mkcert#installation).

To generate certs for a project, run in a project directory:

```bash
# generate cert for a project
fin debug -c 'mkdir -p ${CONFIG_CERTS}; mkcert -key-file ${CONFIG_CERTS}/${VIRTUAL_HOST}.key -cert-file ${CONFIG_CERTS}/${VIRTUAL_HOST}.crt *.${VIRTUAL_HOST} ${VIRTUAL_HOST}'
# reset vhost-proxy to pick-up the new cert
fin system reset vhost-proxy
```

This generates certs based on the project's `VIRTUAL_HOST` (for `VIRTUAL_HOST` and `*.VIRTUAL_HOST`). 
You can tweak the command to generate and install certs for arbitrary domains.

Open https://[project].docksal to validate.

## Setup and Usage (via addon)

mkcert can also be installed as an [addon](https://github.com/docksal/addons/tree/master/mkcert). 

```bash
fin addon install mkcert
```

This will download and install `mkcert` binary in `$HOME/.docksal/bin/mkcert` **except** when `mkcert` is already 
installed globally in the system. 

To generate certs for a project, run in a project directory:

```bash
# generate cert for a project
fin mkcert create
# reset vhost-proxy to pick-up the new cert
fin system reset vhost-proxy
```

Open https://[project].docksal to validate.
