---
title: "Xdebug"
aliases:
  - /en/master/tools/xdebug/
---

Xdebug can be used to debug both web requests as well as cli scripts (e.g., Drush commands).

## Stack Setup {#setup}

Xdebug integration is disabled by default as it causes a roughly 20% performance hit. To enable it:

```bash
fin config set --env=local XDEBUG_ENABLED=1
fin project start
```

To verify that Xdebug was enabled:

```bash
$ fin exec php -v | grep -i xdebug
    with Xdebug v3.0.1, Copyright (c) 2002-2020, by Derick Rethans
```

Next, follow the IDE specific setup steps:

- [PHPStorm](#phpstorm)
- [Visual Studio Code](#vscode)
- [NetBeans](#netbeans)
- [Atom](#atom)


## Debugging with PHPStorm {#phpstorm}

First, follow the [setup instructions](#setup) to enable the Xdebug integration.

### Automatic Setup {#phpstorm-automatic}

PHPStorm makes debugging setup very easy using the [Incoming Connection Dialog](https://www.jetbrains.com/help/idea/incoming-connection-dialog.html).

1. Open a project in PHPStorm and set a breakpoint wherever you like
2. Click on the **Start Listening for PHP Debug Connections** button in PHPStorm

    ![PHPStorm Xdebug Listener](/images/xdebug-phpstorm-listener.png)

3. Open the project in a browser

    A debugging session will start and Xdebug will initialize a connection to PHPStorm.

4. Click on **Accept** in the **Incoming Connection From Xdebug** dialogue in PHPStorm

    ![PHPStorm Xdebug Mappings](/images/xdebug-phpstorm-automatic.png)

    PHPStorm automatically configures a server and directory mappings between the host and the server.

Directory mappings are very important, as that's how PHPStorm knows how to map sources on the server to those on
the host. By default, you will not be able to debug anything above the project's `docroot` folder.

If you don't get the **Incoming Connection From Xdebug** dialogue or you need to debug scripts above the `docroot`
directory, see the [manual setup steps](#phpstorm-manual).

### Manual Setup {#phpstorm-manual}

1. Under **Preferences > Languages & Frameworks > PHP > Servers** add a new server
2. Set **Name** and **Hostname** to project's virtual host (e.g., `myproject.docksal`)
3. Configure host to server directory mappings

    Map the project directory on the host to `/var/www/` on the server:

    ![PHPStorm Xdebug Manual](/images/xdebug-phpstorm-manual.png)

With this manual setup you will be able to debug scripts within your project's root (`/var/www/` on the server).

### CLI Scripts {#phpstorm-cli}

First, follow [automatic](#phpstorm-automatic) or [manual](#phpstorm-manual) instructions to configure server and path
mapping settings in PHPStorm.

To debug PHP CLI scripts, we have to tell PHPStorm which **existing** server configuration to use via the
`PHP_IDE_CONFIG` variable. This can be done using the following commands:

```bash
fin config set --env=local 'PHP_IDE_CONFIG=serverName=${VIRTUAL_HOST}'
fin project start
```

{{% notice warning %}}
The script you are trying to debug must reside within the project root directory (`/var/www/`on the server) or
PHPStorm won't be able to access the scripts's source code and debug it.
{{% /notice %}}

### CLI Scripts: Drush {#phpstorm-drush}

To debug custom Drush commands, make the following additional adjustments in PHPStorm settings:

1. Go to **Preferences > Languages & Frameworks > PHP > Debug**
2. Uncheck **Force break at the first line when no path mapping specified**
3. Uncheck **Force break at the first line when a script is outside the project**

    ![PHPStorm Xdebug Drush](/images/xdebug-phpstorm-drush.png)

You can run your scripts in console and debug them in the same way as browser requests. For example, you can run
`fin drush fl` and debug this Drush command from the Features module.


## Debugging with Visual Studio Code {#vscode}

1. Follow the [setup instructions](#setup) to enable the Xdebug integration
2. Install [PHP_Debug](https://marketplace.visualstudio.com/items?itemName=felixfbecker.php-debug) plugin by Felix Becker
3. Configure PHP Debug Settings

    - Click Debug Icon in left sidebar
    - Click Configuration Gear in top bar, select `PHP` from the dropdown list
    - Configure `pathMappings`

    ![Visual Studio Xdebug Settings](/images/xdebug-vscode.jpg)

    Here is an an example of what `launch.json` should look like:

    ```json
    {
      "version": "0.2.0",
      "configurations": [
        {
          "name": "Listen for XDebug",
          "type": "php",
          "request": "launch",
          "port": 9000,
          "pathMappings": {
            "/var/www/": "${workspaceFolder}"
          }
        },
        {
          "name": "Launch currently open script",
          "type": "php",
          "request": "launch",
          "program": "${file}",
          "cwd": "${fileDirname}",
          "port": 9000,
          "pathMappings": {
            "/var/www/": "${workspaceFolder}"
          }
        }
      ]
    }
    ```

4. Set a breakpoint
5. Select the **Listen for XDebug** configuration from the dropdown and click **Start Debugging**

You can debug both web requests and cli scripts using this configuration.

### CLI Scripts: Drush {#vscode-drush}

To debug Drush commands using Xdebug and VSCode, add the following to your path mappings under the configuration that begins with `"name": "Listen for XDebug",`

**Drush 8.x**

- Add `"/usr/local/bin/drush": "${workspaceFolder}/bin/drush"` to `pathMappings` in your `launch.json` file.

**Drush 9.x**

- Add `"/usr/local/bin/drush": "${workspaceFolder}/vendor/bin/drush"` to `pathMappings` in your `launch.json` file.


## Debugging with NetBeans {#netbeans}

1. Follow the [setup instructions](#setup) to enable the Xdebug integration
2. Open NetBeans Debugging configuration ("Tools> Options > PHP > Debugging") and set "DebuggerPort" to 9000
3. Open your project in NetBeans
4. Configure project properties:

    - Right mouse click on project name, then "Properties" from the dropdown menu
    - Under "Sources", set correct Web Root folder by clicking "Browse" button (usually it's `docroot`)
    - Under "Run Configuration", use project's virtual host (e.g., `myproject.docksal`) to set the Project URL
    - Click "OK" to save project properties

5. Set a breakpoint wherever you like
6. In NetBeans, with the whole project selected or one of the project files opened and active, press `<CTRL> + <F5>` on your keyboard to start the debugger


## Debugging with Atom {#atom}

1. Follow the [setup instructions](#setup) to enable the Xdebug integration
2. Install [PHP-Debug Plugin](https://atom.io/packages/php-debug)
3. Configure PHP Debug Settings (Preferences > Packages)

    - Search for "php-debug"
    - Click "Settings" button below plugin
    - "Server" can be set to `*`
    - "Server Listen Port" should be set to 9000
    - Make sure "Continue to listen for debug sessions even if the debugger windows are all closed" is checked. This will make the debugger window open automatically.

## XDebug v2 Modifications

For versions of XDebug prior to v3.0.0 (prior to docksal/cli [v2.13](https://github.com/docksal/service-cli/releases/tag/v2.13.0)), 
the following changes will need to be made to the projects `.docksal/docksal.yml`: 

```
services:
    cli:
        environment:
            - XDEBUG_CONFIG=remote_connect_back=0 remote_host=${DOCKSAL_HOST_IP}
```

XDebug v3 switched the default IDE listener port (`xdebug.client_port`) from `9000` to `9003`. 
To avoid introducing a breaking change within the CLI service and with IDEs, Docksal uses port `9000` for both XDebug 
versions (v2 and v3).
