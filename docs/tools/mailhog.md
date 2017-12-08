# MailHog

Sending/capturing email is available via [MailHog](https://github.com/mailhog/MailHog).

!!! warning "Out-of-the box only capturing works"
    For email delivery, you have to point MailHog to a working mail server/service.

## Setup

### Mail service

Add the `mail` service in `.docksal/docksal.yml` under `services`.

```yaml
mail:
  hostname: mail
  image: mailhog/mailhog
  expose:
    - "80"
  environment:
    - MH_API_BIND_ADDR=0.0.0.0:80
    - MH_UI_BIND_ADDR=0.0.0.0:80
  labels:
    - io.docksal.virtual-host=webmail.${VIRTUAL_HOST}
  user: root
```

Apply new configuration with `fin project start` (`fin p start`).

### PHP settings

In `.docksal/etc/php/php.ini` in the project repo add the following:

```ini
; Mail settings
sendmail_path = '/usr/local/bin/mhsendmail --smtp-addr=mail:1025'
```

MailHog web UI will be available at `http://webmail.<project_name>.docksal`.
