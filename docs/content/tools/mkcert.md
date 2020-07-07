# mkcert

A [mkcert](https://github.com/FiloSottile/mkcert) generated cert will be trusted locally by:

- Firefox (Linux & Mac)
- Chrome & Chromium
- curl & wget

The cert is automatically generated for `VIRTUAL_HOST` and `*.VIRTUAL_HOST`.

## Installation

Please see [mkcert system installation requirements](https://github.com/FiloSottile/mkcert#installation) before installing.

The `mkcert` binary is installed in `$HOME/.docksal/bin/mkcert` **except** when `mkcert` is already installed globally. 

## Setup (manual)

```bash
# generate cert for a project
$ fin debug -c 'mkdir -p ${CONFIG_CERTS}; mkcert -key-file ${CONFIG_CERTS}/${VIRTUAL_HOST}.key -cert-file ${CONFIG_CERTS}/${VIRTUAL_HOST}.crt *.${VIRTUAL_HOST} ${VIRTUAL_HOST}'
# reset vhost-proxy to pick-up the new cert
$ fin system reset vhost-proxy
```

## Setup (as a project addon)

mkcert can also be installed as a project [addon](https://github.com/docksal/addons/tree/master/mkcert). 

```bash
fin addon install --global mkcert
```

### Addon Use

In a project directory, run:

```bash
fin mkcert create
fin project restart
```

Open https://[project].docksal to validate.
