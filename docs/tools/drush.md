Drush is a command line shell and Unix scripting interface for Drupal.

Please refer to the official [Drush docs](http://www.drush.org/en/master/) for usage details.

## Setup

Drush 8 is installed globally in the `cli` container. No additional setup in necessary.  

For Drupal 8 sites it is recommended to install Drush as a project level dependency via Composer.  
In such cases global drush instance will act as a launcher for the project level one.

If you Composer project doesn't yet depend on Drush, run `composer require drush/drush` to add it.

## Usage 

From the host via `fin`:

```
fin drush --version
```

From with the cli container (`fin bash`) drush can be called directly:

```
drush --version
```

!!! note "Drush must be run inside the Drupal document root"
    Unless globally accessible site aliases are used, Drush must be run inside the Drupal document root to be able to
    detect the Drupal instance and read the DB connection settings.

<a name="site-aliases"></a>
## Drush site aliases

There are several places where Drush looks for the alias files.

The following locations will work in Docksal:

```bash
$DOCROOT/drush/aliases
$DOCROOT/sites/all/drush/aliases
$DOCROOT/../drush/aliases
```

Where `$DOCROOT` is the project's `docroot` folder.

Recommended location is `$DOCROOT/../drush/aliases` which is usually equals `$PROJECT_ROOT/drush/aliases`.

To check the list of available site aliases run `fin drush sa`. Project specific site aliases are only visible when running drush within the project's `docroot` folder.

Use them directly using `fin drush @alias command` or inside `fin bash`.

For more information on drush site aliases see [example.aliases.drushrc.php](https://github.com/drush-ops/drush/blob/master/examples/example.aliases.drushrc.php).
