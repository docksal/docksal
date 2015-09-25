# Directory structure

Drude enforces a directory structure where you have an arbitrary located and named `projects` folder.  
All you projects go into subfolders under the `projects` folder.  

dsh will install necessary boot2docker-vagrant VM files (`Vagrantfile` and `vagrant.yml`) into the `projects` folder.

```
+ ...
 - projects
 |--- your-drupal-site
 |      docker-compose.yml
 |      docroot
 |      ...
 | 
 |--- your-another-drupal-site
 |      .drude
 |      docker-compose.yml
 |      docroot
 |      ...
 | 
 |--- Vagrantfile (not needed on Linux)
 |--- vagrant.yml (not needed on Linux)
```
