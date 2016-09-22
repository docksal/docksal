# Configure a project to use Docksal

Initial configuration is done once per project (e.g. by a team lead) and committed into the project repo.  
Presence of the `.docksal` folder in the repo is good indicators that a project is using Docksal.

**On Windows** make sure your projects are **not** stored inside `%USERPROFILE%/.babun` folder.
 
## Setup

1. Edit `settings.php` for your site (see [Drupal settings](/docs/drupal-settings.md)).
2. Open console (Babun on Windows) to the project directory.
3. Install a default Docksal configuration file (this downloads the latest `docker-compose.yml` file):
    
    ```
    fin install docksal-config
    ```

4. Update `docker-compose.yml` as necessary.

5. Start project stack with:

    ```
    fin up
    ```

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a [custom command](custom-commands.md).  
E.g. `fin init`, which will call `.docksal/commands/init`. Put project specific initialization tasks there, like:

- initialize Docksal configuration
- import database or perform a site install
- compile SASS
- run DB updates, revert features, clear caches, etc.
- enable/disable modules, update variable values
- run Behat tests

For a fully working example of a Docksal powered project (including `fin init`) take a look at:
- [Drupal 7 sample project](https://github.com/docksal/drupal7)
- [Drupal 8 sample project](https://github.com/docksal/drupal8)
