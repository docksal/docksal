---
title: "Composer"
---


Composer is a tool for dependency management in PHP. It allows you to declare the libraries your project depends on and it will manage (install/update) them for you.

Please refer to the official [Composer documentation](https://getcomposer.org/doc/) for usage details.


## Usage

From the host via `fin`:

```
fin composer --version
```

From with the cli container (`fin bash`) composer can be called directly:

```
composer --version
```

{{% notice note %}}
Unless the `--working-dir=` is used, the composer command must be run within the directory or child directory containing the 
project's `composer.json` file.
{{% /notice %}}
