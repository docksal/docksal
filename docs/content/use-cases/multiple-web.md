---
title: "Multiple Web Containers"
weight: 1
---

For projects that need multiple web containers but need to stay in the same Docksal project (e.g., headless Drupal 
backend with a node-based frontend), add a second web service to your `docksal.yml` file:

```
# Web 2 (name it anything you want, doesn't have to be "web2")
web2:
  extends:
    file: ${HOME}/.docksal/stacks/services.yml
    service: apache
  environment:
    - APACHE_DOCUMENTROOT=/var/www/your-web2-directory
  labels:
    - io.docksal.virtual-host=web2.${VIRTUAL_HOST}
```
