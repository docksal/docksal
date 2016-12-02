# Debugging with Docksal, Xdebug and PhpStorm

`xdebug` extension is disabled by default as it causes about 20% performance hit.

There two variants: you can use xdebug for debuging requests from browser or you can debug requests from console (for example Drush commands).

For configuration first variant use **Prerequisites** and **Setup**.

For configuration second variant use **Setup for console php**.

## Prerequisites

- [PHPStorm](https://www.jetbrains.com/phpstorm/)
- [Xdebug Helper](https://chrome.google.com/extensions/detail/eadndfjplgieldjbigjakmdgkmoaaaoc) extension for Chrome

    You can also pick from the [list](https://confluence.jetbrains.com/display/PhpStorm/Browser+Debugging+Extensions) of options for other browsers

## Setup

1. Set environment variable on the `cli` service

    ```yml
    cli:
      ...
      environment:
        - XDEBUG_ENABLED=1
      ...
    ```
2. Update container configuration with `fin up`
3. Open your project in PHPStorm
4. Set a breakpoint wherever you like
5. Click on the **Start Listening for PHP Debug Connections** button in PHPStorm

    ![Screenshot](img/xdebug-toggle-listener.png)

6. Click on **Debug** in **Xdebug Helper** in Chrome

    ![Screenshot](img/xdebug-toggle-debugger.png)

7. Click on **Accept** in the **Incoming Connection From Xdebug** dialogue in PHPStorm

    ![Screenshot](img/xdebug-mapping.png)

Happy debugging!

## Setup for console php
1. Set environment variable on the `cli` service

    ```yml
    cli:
      ...
      environment:
        - XDEBUG_ENABLED=1
        - XDEBUG_CONFIG=idekey=PHPSTORM remote_host=192.168.10.1
        - PHP_IDE_CONFIG=serverName=drupal7.docksal
      ...
    ```
    
   You need to replace **drupal7.docksal** with your domain. You can find it in `docksal.env` section:
   ```yml
      ...
      # Docksal configuration.
      VIRTUAL_HOST=drupal7.docksal
      ...
   ```

2. Update container configuration with `fin up`
3. You can run your scripts from console and debug it in the same way as requests from browser.

For example you can run drush command: `fin drush fra -y` and debug this drush command from feature module.

### Resources

- [Zero-configuration Web Application Debugging with Xdebug and PhpStorm](https://confluence.jetbrains.com/display/PhpStorm/Zero-configuration+Web+Application+Debugging+with+Xdebug+and+PhpStorm)
