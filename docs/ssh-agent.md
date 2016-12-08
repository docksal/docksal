# Using ssh-agent service

ssh-agent service allows adding multiple keys (including ones protected with a passphrase) to a single pool of ssh keys,
which can be shared across multiple projects.

# Setup

1. Add the following configuration option to the `cli` service in the project's `.docksal/docksal.yml` file:

    ```yml
    cli:
      ...
      volumes_from:
        - container:ssh-agent
      ...
    ```
2. Reset the cli container `fin reset cli`.

See `fin help ssh-add` for more information and usage guidelines.
