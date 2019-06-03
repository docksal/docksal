---
title: "Override Command"
---

By default, `cli` runs `supervisord` which runs `php-fpm`, `crond`, and `sshd` daemons.

You can override which command to run on `cli` container start.

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
