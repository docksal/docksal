# Sending and capturing email

Sending/capturing email is available via [MailHog](https://github.com/mailhog/MailHog).

    Note: Out-of-the box only capturing works.
    For email delivery, you have to point MailHog to a working mail server/service.

## Setup

### Mail service

Add the `mail` service in `.docksal/docksal.yml` under `services`.

```
mail:
  hostname: mail
  image: mailhog/mailhog
  expose:
    - "80"
  environment:
    - MH_API_BIND_ADDR=0.0.0.0:80
    - MH_UI_BIND_ADDR=0.0.0.0:80
    - VIRTUAL_HOST=webmail.${VIRTUAL_HOST}
  labels:
    - io.docksal.virtual-host=webmail.${VIRTUAL_HOST}
```

Apply new configuration with `fin up`.

### PHP settings

In `.docksal/etc/php/php.ini` in the project repo add the following:

```
; Mail settings
sendmail_path = '/usr/local/bin/mhsendmail --smtp-addr=mail:1025'
```

MailHog web UI will be available at `http://webmail.<project_name>.docksal`.
