---
title: "Headless Browsers"
aliases:
  - /en/master/tools/headless-browsers/
  - /tools/headless-browsers/
---

Docksal does not maintain headless browser images. The various SeleniumHQ
images are sufficient. Docksal includes support for the following headless
browser images:

- selenium/standalone-chrome
- selenium/standalone-firefox
- selenium/standalone-edge

To include one or more of these browsers with your project, update the 
`services` section of `.docksal/docksal.yml` by adding:

**Chrome**

```yaml
  chrome:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: chrome-browser
```

**Firefox**

```yaml
  firefox:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: firefox-browser
```

**Edge**

```yaml
  edge:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: edge-browser
```

## Enabling the browsers

By default, unless further action is taken, `fin up` _will not_ bring up any
headless browser services that have been included in your project. You can
start the service(s) in one of two ways:

- Running `fin up chrome` which will bring up the `chrome` service.
- Add `COMPOSER_PROFILES="docksal-testing"` to `.docksal/docksal.env` or 
`.docksal/docksal-local.env`, and then run `fin up`. This will bring up all
services in your project tagged with the `docksal-testing` profile (See 
https://docs.docker.com/compose/profiles/ for more information about profiles).
