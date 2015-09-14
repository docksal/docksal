# Zero-configuration Debugging with Xdebug and PhpStorm

With Drude and PHPStorm you are **3 clicks away** from being able to debug your Drupal site or app.

## Prerequisites

- [Drude](https://github.com/blinkreaction/drude)
- [PHPStorm](https://www.jetbrains.com/phpstorm/)
- [Xdebug Helper](https://chrome.google.com/extensions/detail/eadndfjplgieldjbigjakmdgkmoaaaoc) extension for Chrome

    You can also pick from the [list](https://confluence.jetbrains.com/display/PhpStorm/Browser+Debugging+Extensions) of options for other browsers

## Setup

1. Open your project in PHPStorm
2. Set a breakpoint whereever you like
3. Click (#1) on the **Start Listening for PHP Debug Connections** button in PHPStorm

    <img src="img/xdebug-toggle-listener.png" />

4. Click (#2) on **Debug** in **Xdebug Helper** in Chrome

    <img src="img/xdebug-toggle-debugger.png" />

5. Click (#3) on **Accept** in the **Incoming Connection From Xdebug** dialogue in PHPStorm

    <img src="img/xdebug-mapping.png" />

6. Done.

Happy debugging!

### Resources

- [Zero-configuration Web Application Debugging with Xdebug and PhpStorm](https://confluence.jetbrains.com/display/PhpStorm/Zero-configuration+Web+Application+Debugging+with+Xdebug+and+PhpStorm)
