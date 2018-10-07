---
title: "Varnish"
---


Add the `varnish` service under the `services` section in `.docksal/docksal.yml`:

```yaml
  # Varnish
  varnish:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: varnish
    depends_on:
      - web
```

Apply new configuration with `fin project start` (`fin p start`).

Use `http://varnish.<VIRTUAL_HOST>` to access the site via Varnish.


## Custom VCL

Custom VCL is automatically loaded from `.docksal/etc/varnish/default.vcl` if one exists in the project codebase. 
After making changes to the custom VCL file, reset Varnish with `fin project reset varnish` (`fin p reset varnish`).


See [docksal/service-varnish](https://github.com/docksal/service-varnish) for additional configuration options and 
default VCL configs.
