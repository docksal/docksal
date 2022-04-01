---
title: "PHPMyAdmin"
aliases:
  - /en/master/tools/phpmyadmin/
---


[PHPMyAdmin](https://www.phpmyadmin.net/) is a web-based administration tool for MySQL.


## Setup (manual)

Add the `pma` service under the `services` section in `.docksal/docksal.yml`:

```yaml
  # PHPMyAdmin
  pma:
    hostname: pma
    image: phpmyadmin/phpmyadmin
    environment:
      - PMA_HOST=db
      - PMA_USER=root
      - PMA_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}
    labels:
      - io.docksal.virtual-host=pma-${VIRTUAL_HOST}
```

Apply new configuration with `fin project start` (`fin p start`).

Use `http://pma-<VIRTUAL_HOST>` to access the PHPMyAdmin web UI.


## Setup (as a project addon)

PHPMyAdmin can also be installed as a project [addon](https://github.com/docksal/addons/tree/master/pma). 

Run the following command within your project folder:

```bash
fin addon install pma
```
