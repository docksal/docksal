# Using Blackfire profiler

## Setup

Register with [blackfire.io](https://blackfire.io/signup).

**Option 1**

With this option the API keys are stored on the host and never exposed in the code.

---

Use [Blackfire Docker instructions](https://blackfire.io/docs/integrations/docker) to get a `~/.bashrc` snippet. 
This will set the API keys globally.

Add the `blackfire` service to `.docksal/docksal.yml` under `services`:

```yaml
blackfire:
  image: blackfire/blackfire
  environment:
    # Uses host's BLACKFIRE_SERVER_ID and BLACKFIRE_SERVER_TOKEN environment variables.
    - BLACKFIRE_SERVER_ID
    - BLACKFIRE_SERVER_TOKEN
    # Log verbosity level (4: debug, 3: info, 2: warning, 1: error).
    #- BLACKFIRE_LOG_LEVEL=4
```

If you also want to be able to debug PHP cli tools, update `cli` service as follows:

```yaml
cli:
  ...
  environment:
    ...
    # Exposes host's BLACKFIRE_CLIENT_ID and BLACKFIRE_CLIENT_TOKEN environment variables.
    - BLACKFIRE_CLIENT_ID
    - BLACKFIRE_CLIENT_TOKEN
    ...
```

---

**Option 2**

With this option the API keys are backed into the project configuration. 

---

Add the `blackfire` service to `.docksal/docksal.yml` under `services`:

```yaml
blackfire:
  image: blackfire/blackfire
  environment:
    # Use global environment credentials.
    - BLACKFIRE_SERVER_ID=<Server ID>
    - BLACKFIRE_SERVER_TOKEN=<Server Token>
    # Log verbosity level (4: debug, 3: info, 2: warning, 1: error).
    #- BLACKFIRE_LOG_LEVEL=4
```

If you also want to be able to debug PHP cli tools, update `cli` service as follows:

```yaml
cli:
  ...
  environment:
    ...
    # Exposes host's BLACKFIRE_CLIENT_ID and BLACKFIRE_CLIENT_TOKEN environment variables.
    - BLACKFIRE_CLIENT_ID=<Client ID>
    - BLACKFIRE_CLIENT_TOKEN=<Client Token>
    ...
```

Replace `<Server ID>`, `<Server Token>` (`<Client ID>`, `<Client Token>`) with the API keys from your blackfire.io [profile page](https://blackfire.io/account).

---

Apply the new configuration with `fin project start` (`fin p start`).


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
 
For additional information and examples see Blackfire's official documentation: [Profiling CLI Commands](https://blackfire.io/docs/cookbooks/profiling-cli)
