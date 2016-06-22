# Using ssh-agent service

ssh-agent service allows adding multiple keys (including ones protected with a passphrase) to a single pool of ssh keys,
which can be shared across multiple projects.

Required dsh version: `1.20.0+`

# Setup

1. Make sure dsh version is `1.20.0` or higher.
2. `dsh reset ssh-agent` (only necessary when updating from older versions) 
3. Add the following configuration option to the `cli` service in your projects `docker-compose.yml` file

    ```yml
    cli:
      ...
      volumes_from:
        - ssh-agent
      ...
    ```
4. Update container configuration with `dsh up`
5. See `dsh help ssh-agent` for more usage information.
