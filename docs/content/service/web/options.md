---
title: "web: Service Options"
weight: 1
---

The default stack uses Apache for the db service while the pantheon and platformsh stacks use nginx.
If you use the default stack, you do not have to make any configuration changes to use Apache, but 
if you want to specify the use of nginx, you will need to modify your `docksal.yml` file.


## nginx Configuration {#nginx-config}

Docksal has defined a web service with an nginx image. To set your web service to use
nginx instead of Apache, set the web service in your `docksal.yml` file.

```yaml
version: "2.1"
services:
  web:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: nginx
```

{{% notice note %}}
Remember to run `fin project start` (`fin p start`) to apply the configuration.
{{% /notice %}}
