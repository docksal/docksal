---
title: "Elastic Search"
aliases:
  - /en/master/tools/elastic-search/
---


Add the `elasticsearch` service under the `services` section in `.docksal/docksal.yml`:

```yaml
  # Elastic Search
  elasticsearch:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: elasticsearch
```

Apply new configuration with `fin project start` (`fin p start`).

Use `fin project status` to determine which port Elastic Search is exposed on.

Alternatively manually export Elastic Search on the port `9200`:

```bash
  # Elastic Search
  elasticsearch:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: elasticsearch
    ports:
      - "9200:9200"
```
