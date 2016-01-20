# Directory structure

Drude enforces a directory structure where you have an arbitrary located and named `projects` folder.  
All your projects go into subfolders under the `projects` folder.  

`dsh` will install the necessary boot2docker-vagrant VM files (`Vagrantfile` and `vagrant.yml`) into the `projects` folder.

```
+ ...
 - projects
 |--- drupal-site
 |      docker-compose.yml
 |      docroot
 |      ...
 | 
 |--- another-drupal-site
 |      .drude
 |      docker-compose.yml
 |      docroot
 |      ...
 | 
 |--- Vagrantfile (not needed on Linux)
 |--- vagrant.yml (not needed on Linux)
```
