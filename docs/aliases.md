# Aliases for folder in fin

Usually fin executes in context of current folder. With use of aliases you can
have fin to execute in context of another folder without navigating to it.

Create alias `demo` that is linked to `~/Projects/demo`:

```bash
fin alias ~/Projects/demo demo
```

Now you can execute commands for `demo` project from anywhere:

```bash
fin @demo up
fin @demo ps
```

There is a special case that allows you to execute `drush`, it finds `docroot` automatically
if alias points to project's root:

```bash
fin @demo drush updb
```

You can use Drush aliases along with fin aliases. Execute status for `@dev` Drush alias of the `demo` project:

```bash
fin @demo drush @dev status
```

You can link to any folder with fin aliases. This can be useful if you want to link to Drupal's subsite folder.