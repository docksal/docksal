---
title: "Blackfire"
---


Using Blackfire Profiler service to profile your PHP applications.


## Setup

Register with [blackfire.io](https://blackfire.io/signup).

Open [Blackfire Account Credentials](https://blackfire.io/my/settings/credentials) to find your API keys.

---

**Option 1**

With this option, the API keys are stored on your host and not exposed in the project's codebase.

```bash
fin config set --global BLACKFIRE_CLIENT_ID=<blackfire-client-id>
fin config set --global BLACKFIRE_CLIENT_TOKEN=<blackfire-client-token>
fin config set --global BLACKFIRE_SERVER_ID=<blackfire-server-id>
fin config set --global BLACKFIRE_SERVER_TOKEN=<blackfire-server-token>
```

Note: The values will be stored in `$HOME/.docksal/docksal.env` on your host.

---

**Option 2**

With this option, the API keys are stored in the project's codebase. 

```bash
fin config set BLACKFIRE_CLIENT_ID=<blackfire-client-id>
fin config set BLACKFIRE_CLIENT_TOKEN=<blackfire-client-token>
fin config set BLACKFIRE_SERVER_ID=<blackfire-server-id>
fin config set BLACKFIRE_SERVER_TOKEN=<blackfire-server-token>
```

Note: The values will be stored in `.docksal/docksal.env` in the project's codebase.

---

Add the `blackfire` service under the `services` section in `.docksal/docksal.yml`:

```yaml
services:
...
  # Blackfire
  blackfire:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: blackfire
...
```

Apply new configuration with `fin project start` (`fin p start`).


## Usage

Follow the instructions to install and use blackfire via the [Chrome extension](https://blackfire.io/docs/integrations/chrome).

See [blackfire.io](https://blackfire.io/docs/introduction) for more docs on using blackfire; including support for other browsers.


## Debugging cli commands

Use `fin exec blackfire run <command>` from host or `blackfire run <command>` within `cli` to profile cli commands.

Example:

```bash
$ fin exec blackfire run drush version
 Drush Version   :  8.1.11 


Blackfire Run completed
Graph URL https://blackfire.io/profiles/xxxxxxxxxx/graph
No tests! Create some now https://blackfire.io/docs/cookbooks/tests
No recommendations

Wall Time     323ms
CPU Time        n/a
I/O Time        n/a
Memory       8.56MB
Network         n/a     n/a     n/a
SQL             n/a     n/a
```
 
For additional information and examples see Blackfire's official documentation: [Profiling CLI Commands](https://blackfire.io/docs/cookbooks/profiling-cli).
