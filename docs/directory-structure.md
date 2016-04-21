# Directory structure

Drude enforces a directory structure where all your projects go into subfolders under the main `<projects>` folder.  
The `<projects>` folder can be arbitrarily located and named. It is best to put it on the fastest drive you have.

`dsh` will install the necessary boot2docker-vagrant VM files (`Vagrantfile` and `vagrant.yml`) into the `<projects>` folder.

```
+ ...
 - <projects>
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
