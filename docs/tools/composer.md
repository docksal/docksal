# Using Composer

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

!!! note "Composer must be run inside the same directory as composer.json"
    Unless the the `--working-dir=` is used composer must be ran within the same directory or a child of that directory
    as the projects composer.json

