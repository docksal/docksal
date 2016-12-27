# Configure drush aliases for Docksal project

When working with Acquia hosted projects you often need to work with remote aliases,
usually to perform `drush sql-sync` or `drush sql-dump`.

Provided you already have your aliases file(s) in your `~/.drush/` folder to enable their
use with `fin` you need to:

**1.** In your project root (where `.docksal` is) create directory `drush/aliases`

```
mkdir -p drush/aliases
```

**2.** Copy your `*.aliases.drushrc.php` file(s) over into that folder

Now you will be able to run drush commands using these aliases from `fin bash` or directly
with `fin drush @alias command`
