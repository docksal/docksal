---
title: "Multiple Solr Cores"
weight: 1
---

## Default Image Solr 4

To set up multiple Solr cores for use with the [Drupal Search API Solr module](https://www.drupal.org/project/search_api_solr),
modify your `.docksal/docksal.yml` or `.docksal/docksal-local.yml` file with the following:


```
services:
  solr:
    extends:
      file: ${HOME}/.docksal/stacks/services.yml
      service: solr
    labels:
      io.docksal.virtual-host: solr.a.docksal,solr.b.docksal
    volumes:
      - ${PROJECT_ROOT}/.docksal/etc/solr/a:/opt/solr/example/solr/a:ro
      - /var/lib/solr/a/data:rw
      - ${PROJECT_ROOT}/.docksal/etc/solr/b:/opt/solr/example/solr/b:ro
      - /var/lib/solr/b/data:rw
```
Create the file `.docksal/etc/solr/a/core.properties` for instance a with the contents:
```
name=a
dataDir=/var/lib/solr/a/data
```
Create the file `.docksal/etc/solr/b/core.properties` for instance b with the contents:
```
name=b
dataDir=/var/lib/solr/b/data
```

## Using Solr 6

Docksal current has Solr 4 defined in the Docksal images. For users with a need to use Solr 6.x, you can set this in 
your `docksal.yml` file.

```
  solr:
    volumes:
      - ${PROJECT_ROOT}/.docksal/etc/solr/a:/opt/solr/server/solr/a:ro
      - ${PROJECT_ROOT}/../data/a/solr:/var/solr/a/data:rw
      - ${PROJECT_ROOT}/.docksal/etc/solr/b:/opt/solr/server/solr/b:ro
      - ${PROJECT_ROOT}/../data/b/solr:/var/solr/b/data:rw
    image: solr:6.6-alpine
```
Create the file `.docksal/etc/solr/a/core.properties` for instance a with the contents:
```
dataDir=/var/solr/a/data
```
Create the file `.docksal/etc/solr/b/core.properties` for instance b with the contents:
```
dataDir=/var/solr/b/data
```

The files in .docksal/etc/solr/a/conf and .docksal/etc/solr/b/conf will also need to be updated too. If you are upgrading 
from another version of solr, then I suggest that you delete the contents of the data directory and re-index.