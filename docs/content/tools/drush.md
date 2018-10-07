---
title: "Drush"
---


Drush is a command line shell and Unix scripting interface for Drupal.

Please refer to the official [Drush docs](http://docs.drush.org/) for usage details.


## Setup

With the move to composer base workflow, the recommended way of setting up Drush is via a project level composer 
dependency. If your Drupal 8 project does not yet have Drush as a dependency, 
run `composer require drush/drush` to add it. 

[Drush Launcher](https://github.com/drush-ops/drush-launcher) is also installed globally in the `cli` container. 
It will automatically pickup project level drush version and pass execution to it.

For legacy setups and older Drupal versions, `cli` also ships with a globally installed Drush 8. 
The launcher is configured to use it as a fallback when no project level drush is available.


## Usage 

From the host via `fin`:

```
fin drush --version
```

From with the cli container (`fin bash`) drush can be called directly:

```
drush --version
```

{{% notice note %}}
Unless globally accessible site aliases are used, Drush must be run inside the Drupal document root to be able to
detect the Drupal instance and read the DB connection settings.
{{% /notice %}}

<a name="site-aliases"></a>
## Drush site aliases

**Drush 8**

There are several places where Drush looks for the alias files.

The following locations will work in Docksal:

```bash
$DOCROOT/drush/aliases
$DOCROOT/sites/all/drush/aliases
$DOCROOT/../drush/aliases
```

Where `$DOCROOT` is the project's `docroot` folder.

The recommended location is `$DOCROOT/../drush/aliases` which usually equals to `$PROJECT_ROOT/drush/aliases`.

To check the list of available site aliases run `fin drush sa`. 
Project specific site aliases are only visible when running drush within the project's `docroot` folder.  
Use them directly using `fin drush @alias command` or inside `fin bash`.

For more information on drush site aliases see 
[example.aliases.drushrc.php](https://github.com/drush-ops/drush/tree/8.x/examples/example.aliases.drushrc.php).

**Drush 9**

Drush 9 uses `yml` files to store configuration.  
See [example.site.yml](https://github.com/drush-ops/drush/blob/master/examples/example.site.yml) for more information.

You can use the following locations to store site aliases with Drush 9:

The following locations will work in Docksal:

```bash
$DOCROOT/drush/sites
$DOCROOT/../drush/sites
```

Where `$DOCROOT` is the project's `docroot` folder.

These locations are no longer searched recursively in Drush 9; 
alias files must appear directly inside one of the search locations, or it will not be found.
