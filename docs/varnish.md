# Enabling Varnish support

## Setup

1. Comment out `VIRTUAL_HOST=<project_name>.docksal` in the `web` service definition in `docker-compose.yml`.

2. Add `varnish` service in `docker-compose.yml`

    Replace `<project_name>` with your project name.
    
    ```
    # Varnish node
    varnish:
      hostname: varnish
      image: docksal/varnish:3.0-stable
      links:
        - web
      environment:
        - VARNISH_BACKEND_HOST=web.<project_name>.docker
        - VIRTUAL_HOST=<project_name>.docksal
    ```

3. Apply new configuration with `fin up`


See https://github.com/docksal/image-varnish for additional configuration options.
