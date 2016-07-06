# Using Blackfire profiler

## Setup

1. Register with https://blackfire.io.

2. Add `blackfire` service in `docker-compose.yml` and configure API keys:

    **Option 1:** Use [Blackfire Docker instructions](https://blackfire.io/docs/integrations/docker) to get a snippet that you can put in a `.bash_rc`/etc. file globally. Uncomment respective lines in `docker-compose.yml`.

    **Option 2:** Grab **server** API keys from your [profile page](https://blackfire.io/account). 
    Uncomment respective lines in `docker-compose.yml` and replace `Server ID` and `Server Token` with your API keys.
    
    ```yml
    blackfire:
      image: blackfire/blackfire
      environment:
        # Option 1: exposes host's BLACKFIRE_SERVER_ID and TOKEN environment variables.
        #- BLACKFIRE_SERVER_ID
        #- BLACKFIRE_SERVER_TOKEN
        # Option 2: use global environment credentials.
        #- BLACKFIRE_SERVER_ID=<Server ID>
        #- BLACKFIRE_SERVER_TOKEN=<Server Token>
        # Log verbosity level (4: debug, 3: info, 2: warning, 1: error).
        #- BLACKFIRE_LOG_LEVEL=4
    ```

3. For `docker-compose.yml` files using version 1:

    Note: if you do not see `version: 2` in the beginning of your `docker-compose.yml` file, then proceed. 
    Add a link in the `cli` service definition:

    ```yml
    ...
    links:
      ...
      - blackfire
    ...
    ```

4. Apply new configuration with `dsh up`

5. Follow instruction to install and use blackfire via a [Chrome extension](https://blackfire.io/docs/integrations/chrome).

See [blackfire.io](https://blackfire.io/docs/introduction) for more docs on using blackfire including support for other browsers.
