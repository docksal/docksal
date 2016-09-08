# Configure a project to use Docksal

Initial configuration is done once per project (e.g. by a team lead) and committed into the project repo.

`docker-compose.yml` file and `.docksal` folder are good indicators that a project is using Docksal.  

**On Windows** make sure your `projects` folder is **not** inside `%USERPROFILE%/.babun` folder.
 
## Setup

1. Edit `settings.php` for your site (see [Drupal settings](/docs/drupal-settings.md)).
2. Open console (Babun on Windows) and cd into `<projects/your-drupal-site>`.
3. Install default Docksal configuration file (downloads the latest `docker-compose.yml`):
    
    ```
    fin install docksal-config
    ```

4. Update `docker-compose.yml` as necessary.

5. Start Docksal with:

    ```
    fin up
    ```

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](custom-commands.md).  
E.g. `fin init` will call `.docksal/commands/init`, where you can put project specific initialization tasks like:

- initialize Docksal configuration
- import database or perform a site install
- compile sass
- run update, revert features, clear caches, etc.
- enable/disable modules, update variable values
- run Behat tests

For a fully working example of a Docksal powered project (including `fin init`) take a look at:
- [Drupal 7 sample project](https://github.com/docksal/docksal-drupal7)
- [Drupal 8 sample project](https://github.com/docksal/docksal-drupal8)
