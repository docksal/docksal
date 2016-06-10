# Debugging with Drude, Xdebug and PhpStorm

`cli` container has `xdebug` extension inbuilt but it is disabled by default for better performance.  
Performance difference with and without Xdebug is ~20%.  

## Prerequisites

- [PHPStorm](https://www.jetbrains.com/phpstorm/)
- [Xdebug Helper](https://chrome.google.com/extensions/detail/eadndfjplgieldjbigjakmdgkmoaaaoc) extension for Chrome

    You can also pick from the [list](https://confluence.jetbrains.com/display/PhpStorm/Browser+Debugging+Extensions) of options for other browsers

## Setup

1. Set environment variable on `cli` container to enable Xdebug
    ```yml
    cli:
      ...
      environment:
        - XDEBUG_ENABLED=1
    ```
1. Restart services with `dsh up`
1. Open your project in PHPStorm
1. Set a breakpoint wherever you like
1. Click on the **Start Listening for PHP Debug Connections** button in PHPStorm

    <img src="img/xdebug-toggle-listener.png" />

1. Click on **Debug** in **Xdebug Helper** in Chrome

    <img src="img/xdebug-toggle-debugger.png" />

1. Click on **Accept** in the **Incoming Connection From Xdebug** dialogue in PHPStorm

    <img src="img/xdebug-mapping.png" />

Happy debugging!

### Resources

- [Zero-configuration Web Application Debugging with Xdebug and PhpStorm](https://confluence.jetbrains.com/display/PhpStorm/Zero-configuration+Web+Application+Debugging+with+Xdebug+and+PhpStorm)
