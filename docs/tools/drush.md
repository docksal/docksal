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
## Configure drush site aliases for a project

When working with projects hosted on a remote server you would often use drush site aliases.

There are several places where Drush looks for the alias files.  
The following locations will work in Docksal:

```bash
$DOCROOT/drush/aliases
$DOCROOT/sites/all/drush/aliases
$DOCROOT/../drush/aliases
```

Where `$DOCROOT` is the project's `docroot` folder.

To check the list of available site aliases run `fin drush sa`.  
Project specific site aliases are only visible when running drush within the project's `docroot` folders.

With site aliases in place you can use them inside `fin bash` or directly using `fin drush @alias command`

For more information on drush site aliases see [example.aliases.drushrc.php](https://github.com/drush-ops/drush/blob/master/examples/example.aliases.drushrc.php).
