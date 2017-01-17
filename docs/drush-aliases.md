# Configure drush aliases for a Docksal project

When working with projects hosted on a remote server you would often use drush site aliases.

There are several places where Drush looks for the alias files.  
The following locations will work in Docksal:

```
$DOCROOT/drush/aliases
$DOCROOT/sites/all/drush/aliases
$DOCROOT/../drush/aliases
```

Where `$DOCROOT` is the project's `docroot` folder.

To check the list of available site aliases run `fin drush sa`.  
Project specific site aliases are only visible when running drush within the project's `docroot` folders.

With site aliases in place you can use them inside `fin bash` or directly using `fin drush @alias command`

For more information on drush site aliases see [example.aliases.drushrc.php](https://github.com/drush-ops/drush/blob/master/examples/example.aliases.drushrc.php).
