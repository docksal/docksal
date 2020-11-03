---
title: "db: PostreSQL"
---

To use PostgreSQL in a project, add the following service definition to `.docksal/docksal.yml`:

```yaml
version: "2.1"

services:
  db:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: pgsql
```
