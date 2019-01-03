---
title: "NodeJS"
weight: 1
---

## Installing Alternate NodeJS Versions

The Docksal `cli` comes pre-installed with NodeJS 8.11.3. This is the recommended version for most users. If you require
a newer version, you have options:

**Install the needed version of NodeJS via nvm at runtime**

```
fin exec nvm install 10.12.0
# Set the node default version
fin exec nvm alias default 10.12.0
```

Alternatively, you can use `.nvmrc` to set the required NodeJS version for the project:
```
fin exec echo 10.12.0 > .nvmrc
fin exec nvm install
```

To automate this with your project, you can put the command into the project's init script and have it happen 
every time you initialize the project with `fin init`.

Note, that as with any dependency installed at run-time, the image will not be immutable and is also internet connection 
dependent. Every time you reset/re-initialize the project stack and run `fin init`, that extra node version will be 
pulled down from the internet.

**Extend the stock Docksal image**

You can extend the stock Docksal image to add the desired version. There is a [full working example](https://github.com/docksal/example-nodejs)
that demonstrates this very concept.
