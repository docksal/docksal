# Using Blackfire profiler

## Setup

1. Register with [blackfire.io](https://blackfire.io/signup).

2. Add the `blackfire` service to `.docksal/docksal.yml` under `services` and configure API keys:

**Option 1**

Use [Blackfire Docker instructions](https://blackfire.io/docs/integrations/docker) to get a snippet 
that you can put in a `.bash_rc`/etc. file globally.

```yml
blackfire:
  image: blackfire/blackfire
  environment:
    # Exposes host's BLACKFIRE_SERVER_ID and TOKEN environment variables.
    - BLACKFIRE_SERVER_ID
    - BLACKFIRE_SERVER_TOKEN
    # Log verbosity level (4: debug, 3: info, 2: warning, 1: error).
    #- BLACKFIRE_LOG_LEVEL=4
```

**Option 2**

Grab the **server** API keys from your [profile page](https://blackfire.io/account).
Replace `Server ID` and `Server Token` with your API keys.

```yml
blackfire:
  image: blackfire/blackfire
  environment:
    # Use global environment credentials.
    - BLACKFIRE_SERVER_ID=<Server ID>
    - BLACKFIRE_SERVER_TOKEN=<Server Token>
    # Log verbosity level (4: debug, 3: info, 2: warning, 1: error).
    #- BLACKFIRE_LOG_LEVEL=4
```

3. Apply the new configuration with `fin up`.

4. Follow the instructions to install and use blackfire via the [Chrome extension](https://blackfire.io/docs/integrations/chrome).

See [blackfire.io](https://blackfire.io/docs/introduction) for more docs on using blackfire; including support for other browsers.
