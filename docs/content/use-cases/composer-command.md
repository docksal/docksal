---
title: "Docker Composer Override of the Command for the CLI Container"
weight: 1
---

Docker Compose has an ability to configure which command to run on `cli` container start.

```yaml
services:
  cli:
    command: bundle exec thin -p 3000
```

The command can also be in a list:
```yaml
services:
  cli:
    command: ["bundle", "exec", "thin", "-p", "3000"]
```

This can be useful for automatic services initialization, such as:
```yaml
services:
  cli:
    # Using nodemon for live reload
    command: ["bash", "-lc", "nodemon index.js"]
```

Note `bash -lc`, not just `bash -c`, as login shell initializes docker user environment.
