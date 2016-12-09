# Expose any Docker container's port

By default containers' ports are not accessible outside of Docker. Other containers can work with them but you can't access them from your host.

```
$ fin status
     Name                   Command               State        Ports
--------------------------------------------------------------------------
netscout_cli_1   /opt/startup.sh gosu root  ...   Up      22/tcp, 9000/tcp
netscout_db_1    /entrypoint.sh mysqld            Up      3306/tcp
netscout_web_1   /opt/startup.sh apache2 -D ...   Up      443/tcp, 80/tcp
```

Ports in the right column are ports that containers expose to Docker. Follow next steps to expose any of these ports to the host.



1. Create `docksal-local.yml` (it is recommended to keep such configuration there instead of modifying `docksal.yml`)

2. Put following contents into `docksal-local.yml`. They will instruct Docker to export port `22` of `cli` service as port `2222` on your host

    ```
    version: "2"
    services:
      cli:
        ports:
          - "2222:22"
    ```

    ***Note the quotes.** Yaml interprets some numbers with a colon as base 60 numbers, so you need quotes here.*

3. Run `fin up` to apply configuration.

4. Now you can see that your port is exposed. Note `0.0.0.0:2222` pointing to `22`.

    ```
    $ fin status
         Name                   Command               State            Ports
    ---------------------------------------------------------------------------------
    netscout_cli_1   /opt/startup.sh gosu root  ...   Up      0.0.0.0:2222->22/tcp, 9000/tcp
    netscout_db_1    /entrypoint.sh mysqld            Up      3306/tcp
    netscout_web_1   /opt/startup.sh apache2 -D ...   Up      443/tcp, 80/tcp
    ```
