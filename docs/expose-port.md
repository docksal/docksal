# Expose Docker container ports

By default, container ports are not accessible outside of Docker. Other containers can work with them but you can't access them from your host.

```
$ fin status
     Name                   Command               State        Ports
--------------------------------------------------------------------------
netscout_cli_1   /opt/startup.sh gosu root  ...   Up      22/tcp, 9000/tcp
netscout_db_1    /entrypoint.sh mysqld            Up      3306/tcp
netscout_web_1   /opt/startup.sh apache2 -D ...   Up      443/tcp, 80/tcp
```

The container ports in the right column are exposed to Docker. Follow the next steps below to expose any of these ports to the host.



1. Create `docksal-local.yml` (this is recommended to override the configuration instead of modifying `docksal.yml` directly).

2. Put the following contents into `docksal-local.yml`. This will instruct Docker to export port `22` of the `cli` service as port `2222` on your host.

    ```
    version: "2"
    services:
      cli:
        ports:
          - "2222:22"
    ```

    _**Note the quotes.** Yaml interprets some numbers with a colon as base64 numbers, so you need quotes here._

3. Run `fin up` to apply the new configuration.

4. Now you can see that your port is exposed. Note `0.0.0.0:2222` is pointing to `22`.

    ```
    $ fin status
         Name                   Command               State            Ports
    ---------------------------------------------------------------------------------
    netscout_cli_1   /opt/startup.sh gosu root  ...   Up      0.0.0.0:2222->22/tcp, 9000/tcp
    netscout_db_1    /entrypoint.sh mysqld            Up      3306/tcp
    netscout_web_1   /opt/startup.sh apache2 -D ...   Up      443/tcp, 80/tcp
    ```
