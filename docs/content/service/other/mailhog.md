---
title: "MailHog"
aliases:
  - /en/master/tools/mailhog/
  - /tools/mailhog/
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
