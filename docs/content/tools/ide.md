---
title: "Coder Web IDE"
aliases:
  - /en/master/tools/cloud9/
---

[Coder](https://coder.com/) is a free, open-source web IDE based on [Visual Studio Code](https://code.visualstudio.com/) (VS Code).

![Visual Studio Code](https://user-images.githubusercontent.com/1487073/58344409-70473b80-7e0a-11e9-8570-b2efc6f8fa44.png)

With VS Code you can:

- Browse, search, and edit files and folders in the project codebase
- Use console tools available in `docksal/cli` the same way you'd use them with `fin bash`
- Use [GitLens extension](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- Use [XDebug extension](https://marketplace.visualstudio.com/items?itemName=felixfbecker.php-debug) to debug web pages as well as cli scripts
- Install any other extensions from thousands available in the [Visual Studio Code Marketplace](https://marketplace.visualstudio.com/vscode)

## Enabling IDE

{{% notice note %}}
This integration requires `docksal/cli` v2.10.0 or greater.
{{% /notice %}}

To enable the IDE integration for a project:

```bash
# Remove/reset the cli container (only necessary for an existing project stack)
fin project remove cli
# Enable IDE 
fin config set --env=local IDE_ENABLED=1
# Apply new stack configuration
fin project start
```

{{% notice tip %}}
To enable for other developers within the project, remove the `--env=local` option from the above command and commit 
the changes in `docksal.env` into git. 
{{% /notice %}}

After enabling, the IDE can be accessed at `http://ide-PROJECT_NAME.docksal`.


## Password Protecting IDE

When enabling the IDE on a publicly accessible Docksal environment, ensure the IDE is password protected:

```bash
fin config set --env=local IDE_PASSWORD="mypassword"
```

When no value is set, a password is not required to access the IDE.


## Using XDebug

XDebug VS Code extension is pre-installed and pre-configured, however the XDebug PHP extension is not enabled by default.

To enable the XDebug PHP extension:

```bash
fin config set --env=local XDEBUG_ENABLED=1
fin project start
```

To debug web pages in the IDE:

- Set a breakpoint
- Start the "XDebug (listener)" on the "Debug" tab
- Reload the page to initiate a debugging session

![XDebug Demo Web](https://i.imgur.com/xtYI13n.gif)

Similarly, to debug CLI scripts in the IDE:

- Set a breakpoint
- Start the "XDebug (listener)" on the "Debug" tab
- Run the PHP script in the IDE terminal to initiate a debugging session

![Xdebug Demo CLI](https://i.imgur.com/3sNPFRq.gif)


## Other Considerations

IDE runs in a dedicated container in the project stack. The `ide` container and the `cli` container use the same image  
but run different processes inside. They also share the `/home/docker` volume. Changes in the `docker` user's home 
directory will be in sync in both containers (e.g., installing a different NodeJS version). However, installing global 
packages with `apt-get` or making other system level changes inside one container will not have effect on the other one. 

With IDE enabled, you will not be able to individually reset `cli` and `ide` containers. To workaround this, remove 
both containers, then start/update the project stack:

```bash
fin project remove cli ide
fin project start
```
