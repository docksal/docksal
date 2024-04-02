---
title: "Custom Configuration"
weight: 3
aliases:
  - /en/master/advanced/stack-config/
---

Docksal provides a lot of flexibility in the way project stacks can be configured.

You can go from [zero-config](/stack/zeo-configuration/), to [customized](#customized-configuration), to entirely 
[custom](#custom-configuration) stack configurations.

## Customized Configuration {#customized-configuration}

Customized configurations are useful whenever you need a bit (or a lot) more from your project stack.

Such configurations rely on a [managed stack](/stack/understanding-stack-config/#default-configurations), but extend it 
with additional docker-compose overrides and definitions via the `.docksal/docksal.yml` file.

Examples:

- Extend the default stack with the [Mailpit](/service/other/mailpit/) service to capture outbound emails
- Repurpose the `cli` service to [run a different command](/service/cli/override-command/) on startup 
(e.g., a node app instead of PHP-FPM).
- [Pass variables](#pass-variables) from the host/project config inside containers 

### Passing Variables to Containers {#pass-variables}

You may add environment variables that you can pass into containers through the `docksal.env` or `docksal-local.env` files.
These are easily set using `fin config set`:

```bash
fin config set MY_CUSTOM_VARIBLE='test key'
```

Variable values can be statically set or passed from the host. See example below.

```yaml
# docksal.yml
  cli:
    environment:
      - MY_CUSTOM_VARIABLE # Variable value passed from the host environment (values in docksal.env take precedence)
      - MY_STATIC_VARIABLE=api_test_key # Variable value statically set
```

## Custom Configuration {#custom-configuration}

Advanced users can manage their project stack configuration with pure docker-compose. 

Custom configurations do not include a managed stack (this is the key different between custom and customized configurations). 
The complete docker-compose definition is managed via the `.docksa/docksal.yml` file.

To switch to a custom configuration stack, run this in your project directory:

```bash
fin config rm DOCKSAL_STACK
```

Check the resulting docker-compose configuration with `fin config show` and apply with `fin project start` 
or `fin project reset`.

You may notice that Docksal still includes configuration for managed volumes (which depends on the host OS/hypervisor) 
to simplify mounting of the host's file system (notably, the `project_root` volume). 

Volumes can also be disabled, if you'd like to have a completely empty starting point for your docker-compose config. 
To disable managed volumes, run this in the project directory: 

```bash
fin config set DOCKSAL_VOLUMES=disabled
```

Check the resulting docker-compose configuration with `fin config show` and apply with `fin project reset`.

You may still utilize a mix of managed services (from `$HOME/.docksal/stacks/services/yml`) and custom services with 
custom configurations.

{{% notice note %}}
Support for `docksal.env` and environment specific files (e.g., `docksal-local.env`, `docksal-local.yml`) will still 
work with custom configurations.
{{% /notice %}}

### Don't Break Your Docksal Setup! List of Must Have Values {#warning}

{{% notice warning %}}
Certain configuration settings in yaml files are required for your Docksal stack to function properly.
{{% /notice %}}

#### web

In the `web` service, there are settings defined in the `volumes`, `labels`, `environment`, and `depends_on` sections. 
You should not remove or change these values.

```yaml
  web:
    volumes:
      # Project root volume
      - project_root:/var/www:ro,nocopy,cached
    labels:
      - io.docksal.virtual-host=${VIRTUAL_HOST},*.${VIRTUAL_HOST},${VIRTUAL_HOST}.*
      - io.docksal.cert-name=${VIRTUAL_HOST_CERT_NAME:-none}
      - io.docksal.project-root=${PROJECT_ROOT}
      - io.docksal.permanent=${SANDBOX_PERMANENT:-false}
    environment:
      - APACHE_DOCUMENTROOT=/var/www/${DOCROOT:-docroot}
    # cli has to be up before web
    depends_on:
      - cli
```

#### cli

In the `cli` service, there is the `volumes` section. You should not remove or change these volumes.

```yaml
  cli:
    volumes:
      # Project root volume
      - project_root:/var/www:rw,nocopy,cached
      # Shared ssh-agent socket
      - docksal_ssh_agent:/.ssh-agent:ro
```
