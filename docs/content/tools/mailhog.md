---
title: "MailHog"
---


Sending/capturing email is available via [MailHog](https://github.com/mailhog/MailHog).

{{% notice warning %}}
Out-of-the box only capturing works. For email delivery, you have to point MailHog to a working mail server/service.
{{% /notice %}}


## Setup

Add the `mail` service under the `services` section in `.docksal/docksal.yml`:

```yaml
  # MailHog
  mail:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: mail
```

Apply new configuration with `fin project start` (`fin p start`).

Use `http://mail.<VIRTUAL_HOST>` to access the MailHog web UI.


## PHP configuration

{{% notice note %}}
The extra PHP configuration below is only applicable to `docksal/cli` images prior to v2.0.0
{{% /notice %}}

In `.docksal/etc/php/php.ini` in the project repo add the following:

```ini
; Mail settings
sendmail_path = '/usr/local/bin/mhsendmail --smtp-addr=mail:1025'
```

These settings are included in `docksal/cli` v2.0+, so there is no need to manually add them.
