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

2. Install and configure sSMPT in `cli`

    Replace `<project_name>` with your project name.

    ```
    dsh exec "sudo apt-get update && sudo apt-get install ssmtp -y"
    dsh exec "sudo sed -i -e '/mailhub=/c mailhub=mail.<project_name>.docker:1025' -e '/#FromLineOverride=/c FromLineOverride=YES' /etc/ssmtp/ssmtp.conf"
    ```

3. Configure `sendmail_path` in `php.ini`

    Add to `.drude/etc/php5/php.ini` in the project repo
    
    ```
    ; Mail settings
    sendmail_path = "/usr/sbin/ssmtp -t"
    ```

MailHog web UI will be available at `http://webmail.<project_name>.drude`

    These instructions are temporary. Tread them as a POC for using MailHog with Drude.
    Steps 2 has to be performed any time the cli container gets reconfigured, updated or reset.
