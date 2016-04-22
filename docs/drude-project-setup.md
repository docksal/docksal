# Configure a project to use Drude

Initial configuration is done once per project (e.g. by a team lead) and committed into the project repo.

`docker-compose.yml` file and an optional `.drude` folder are good indicators that a project is using Drude.  

**On Windows** make sure your `projects` folder is **not** inside `%USERPROFILE%/.babun` folder.
 
## Setup

1. Edit `settings.php` for your site (see [Drupal settings](/docs/drupal-settings.md)).
2. Open console (Babun on Windows) and cd into `<projects/your-drupal-site>`.
3. Install Drude's docker stack configuration (this downloads the latest `docker-compose.yml` file):
    
    ```
    dsh install drude-config
    ```

4. Update `docker-compose.yml` as necessary.

5. Start the VM and/or containers with:

    ```
    dsh up
    ```

## Automate the initialization process

This is optional, but highly recommended.

Site provisioning can be automated via a shell script.  
`dsh init` will call `.drude/scripts/drude-init.sh`, where you can put project specific initialization tasks, e.g.:

- initialize local settings files (Docker Compose, Drupal, Behat, etc.)
- initialize Drude docker stack
- import DB / perform a site install
- compile Sass
- run DB updates, revert features, clear cached, etc.
- apply local settings (e.g. enable/disable modules, updates variable values)
- run Behat tests available in the repo

For a fully working example of a Drude powered project (including `dsh init`) take a look at:
- [Drupal 7 sample project](https://github.com/blinkreaction/drude-d7-testing)
- [Drupal 8 sample project](https://github.com/blinkreaction/drude-d8-testing)
