---
title: "Xhprof"
aliases:
  - /en/master/tools/xhprof/
---

Xhprof can be used to profile your PHP Application.

## Stack Setup {#setup}

XHProf integration is disabled by default as it causes a performance hit. To enable it:

```bash
fin config set --env=local XHPROF_ENABLED=1
fin project start
```

To verify that Xhprof was enabled:

```bash
$ fin exec php -i | grep -i xhprof
    /usr/local/etc/php/conf.d/docker-php-ext-xhprof.ini,
    extension 'xhprof' detected
    xhprof
    xhprof support => enabled
    xhprof.collect_additional_info => 0 => 0
    xhprof.output_dir => /tmp/xhprof => /tmp/xhprof
    xhprof.sampling_depth => 0x7fffffff => 0x7fffffff
    xhprof.sampling_interval => 100000 => 100000
```

## Drupal

To profile a Drupal application the [Xhprof](https://www.drupal.org/project/xhprof) module can be downloaded
and enabled. Once enabled and `Enable profiling of page views.` has been checked. This should start recording
application calls and performance monitioring.

## PHP Applications

For examples on how to use this with other PHP applications reference the [php.net Examples](https://www.php.net/manual/en/xhprof.examples.php).

## Accessing Callgraphs

Use `http://xhprof.<VIRTUAL_HOST>` to access the Xhprof web UI.
