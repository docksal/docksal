# Sending and capturing email

Sending/capturing email support can be added via [MailHog](https://github.com/mailhog/MailHog).   

    Out-of-the box only capturing will be working.
    For email delivery you will have to point MailHog to a working mail server/service.

## Setup

1. Add the `mail` service in `docker-compose.yml`

    Replace `<project_name>` with your project name.
    
    ```
    mail:
      hostname: mail
      image: mailhog/mailhog
      expose:
        - "80"
      environment:
        - MH_API_BIND_ADDR=0.0.0.0:80
        - MH_UI_BIND_ADDR=0.0.0.0:80
        - DOMAIN_NAME=mail.<project_name>.docker
        - VIRTUAL_HOST=webmail.<project_name>.drude
    ```

    Apply new configuration with `dsh up`

2. Add to `.drude/etc/php5/php.ini` in the project repo
    
    Replace `<project_name>` with your project name.
    
    ```
    ; Mail settings
    sendmail_path = '/usr/local/bin/mhsendmail --smtp-addr=mail.<project_name>.docker:1025'
    ```

    Note: if using `version 2` docker-compose file format, then you may use this instead
    
    ```
    ; Mail settings
    sendmail_path = '/usr/local/bin/mhsendmail --smtp-addr=mail:1025'
    ```

MailHog web UI will be available at `http://webmail.<project_name>.drude`
