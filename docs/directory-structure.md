# Directory structure

All your Docksal projects should be located **under current user's home folder**.

Docksal recommends a directory structure where all your projects go into subfolders under the main `<projects>` folder.  
The `<projects>` folder can be arbitrarily named.

```
 - <projects>
 |--- drupal-site
 |      docker-compose.yml
 |      docroot
 |      ...
 | 
 |--- another-drupal-site
 |      .docksal
 |      docker-compose.yml
 |      docroot
 |      ...
```
