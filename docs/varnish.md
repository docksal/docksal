# Enabling Varnish support

Add the `varnish` service under the `services` section in `.docksal/docksal.yml`

```
# Varnish
varnish:
  hostname: varnish
  image: ${VARNISH_IMAGE:-docksal/varnish:1.0-varnish4}
  labels:
    - io.docksal.virtual-host=varnish.${VIRTUAL_HOST}
  environment:
    - VARNISH_BACKEND_HOST=web
    - VIRTUAL_HOST=varnish.${VIRTUAL_HOST}
```

Apply new configuration with `fin up`.

See [docksal/image-varnish](https://github.com/docksal/image-varnish) for additional configuration options.
